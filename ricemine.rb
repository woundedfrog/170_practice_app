require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'
require 'redcarpet'
require 'yaml'
require 'fileutils'
require 'bcrypt'

configure do
  set :erb, escape_html: true
end

configure do
  enable :sessions
  set :session_secret, 'secret'
end

helpers do
  def special_key?(key)
    %w[pic pic2 pic3 tier stars type element].include?(key.to_s)
  end

  def format_image_from_tier(ratings)
    formated_images = []
    ratings.split(' ').each do |tier|
      formated_images << "<img class=\'short-stat-content tier_rating\' src='/images/class#{tier.downcase}.png'/>"
    end
    formated_images
  end

  def format_stat(stat_key, info_val)
    if %w[water fire grass light dark].include?(info_val)
      "<img class=\'short-stat-content element-type-pic\' src='/images/#{info_val}.png'/>"
    elsif %w[tank attacker buffer healer debuffer].include?(info_val)
      "<img class=\'short-stat-content element-type-pic\' src='/images/#{info_val}.png'/>"
    elsif stat_key == 'stars'
      "<img class=\'short-stat-content star_rating\' src='/images/star#{info_val}.png'/>"
    else
      info_val
    end
  end

  def sort_info_by_given_type(criteria, type)
    keys = []
    criteria.values.each do |hash|
      if type == 'tier'
        hash.each do |k, v|
          next if k != type

          tier_average = (v.split(' ').map(&:to_i).reduce(&:+).to_f / 4).ceil
          keys << tier_average
          keys.sort!
        end
      else
        hash.each { |k, v| keys << v if k == type }
      end
    end

    [type, keys.uniq.sort.map!(&:to_s).reverse]
  end

  def upcase_name(name)
    name.split(' ').map(&:capitalize).join(' ')
  end
end

def delete_selected_file(name)
  if !name.include?('.jpg')
    Dir.glob('./public/images/').each do |f|
      FileUtils.rm(f + name)
    end
  else
    Dir.glob('public/images/sc/').each do |f|
      FileUtils.rm(f + name)
    end
  end
end

def valid_credentials?(username, password)
  credentials = load_user_credentials

  if credentials.key?(username)
    bcrypt_password = BCrypt::Password.new(credentials[username])
    bcrypt_password == password
  else
    false
  end
end

def load_user_credentials
  credentials_path = if ENV['RACK_ENV'] == 'test'
                       File.expand_path('test/users.yml', __dir__)
                     else
                       File.expand_path('users.yml', __dir__)
                     end
  YAML.load_file(credentials_path)
end

def user_signed_in?
  session.key?(:username)
end

def require_user_signin
  return unless user_signed_in? == false

  session[:message] = 'You must be signed in to do that.'
  redirect '/'
end

def file_path
  cards = ''
  units = ''
  if ENV['RACK_ENV'] == 'test'
    cards = File.expand_path('test/public/images/sc/', __dir__)
    units = File.expand_path('test/public/images/', __dir__)
  else
    cards = File.expand_path('public/images/sc/', __dir__)
    units = File.expand_path('public/images/', __dir__)
  end
  [units, cards]
end

def load_soulcards_details
  unit_list = if ENV['RACK_ENV'] == 'test'
                File.expand_path('test/data/sc/soul_cards.yml', __dir__)
              else
                File.expand_path('data/sc/soul_cards.yml', __dir__)
              end
  YAML.load_file(unit_list)
end

def load_new_soulcard
  unit_list = if ENV['RACK_ENV'] == 'test'
                File.expand_path('test/data/sc/new_soul_card.yml', __dir__)
              else
                File.expand_path('data/sc/new_soul_card.yml', __dir__)
              end
  YAML.load_file(unit_list)
end

def load_new_unit
  unit_list = if ENV['RACK_ENV'] == 'test'
                File.expand_path('test/data/new_unit.yml', __dir__)
              else
                File.expand_path('data/new_unit.yml', __dir__)
              end
  YAML.load_file(unit_list)
end

def load_unit_details
  unit_list = if ENV['RACK_ENV'] == 'test'
                File.expand_path('test/data/unit_details.yml', __dir__)
              else
                File.expand_path('data/unit_details.yml', __dir__)
              end
  YAML.load_file(unit_list)
end

def get_unit_name(data_path, index)
  unit_name = ''
  data_path.each do |name, info|
    unit_name = name if info['index'] == index
  end
  unit_name
end

def get_max_index_number(list)
  list.sort_by { |_, v| v['index'] }.to_h
  list.map { |_, v| v['index'] }.max + 1
end

def sort_by_given_info(unit_info, stars, catagory_vals = nil, type = nil)
  star_rating = stars[0]
  by_stars = nil

  if type == 'tier'
    by_stars = unit_info.select do |_, v|
      # averages the 4 tier values
      tier_average = (v['tier'].split(' ').map(&:to_i).reduce(&:+).to_f / 4).ceil.to_s
      # this changes the 4 tier values into 1
      v['tier'] = tier_average
      # checks if it's the right tier and star rating
      (v['stars'] == star_rating) && catagory_vals.include?(tier_average)
    end
    by_stars = by_stars.to_h

  else
    by_stars = unit_info.select { |_, v| v['stars'] == star_rating }.to_h
  end

  by_stars.sort_by { |k, _| k }.to_h
end

def get_unit_or_sc_from_keys(keys)
  cards = load_soulcards_details
  units = load_unit_details
  return [nil, nil] if keys.empty?

  unit_results = find_unit_sc_from_keys(units, keys)
  card_results = find_unit_sc_from_keys(cards, keys)

  [unit_results.to_h, card_results.to_h]
end

def find_unit_sc_from_keys(details, keys)
  results = []

  details.each do |name, info_hash|
    info_hash.each do |key, val|
      if val.to_s.downcase.include?(keys) || key.downcase.include?(keys)
        results << [name, info_hash]
      end
    end
  end
  results
end

def create_file_from_upload(uploaded_file, pic_param, directory)
  if !uploaded_file.nil?
    (tmpfile = uploaded_file[:tempfile]) && (pname = uploaded_file[:filename])
    path = File.join(directory, pname)
    File.open(path, 'wb') { |f| f.write(tmpfile.read) }
  elsif params[:pic].empty?
    pname = 'emptyunit0.png'
  else
    pname = pic_param
  end

  directory.gsub!('public', '')
  pname.include?(directory) ? pname : "#{directory}/" + pname
end

# ##################

def render_markdown(file)
  markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  markdown.render(file)
end

def load_file_content(filename)
  content = File.read(filename)
  render_markdown(content)
end

# ##################

not_found do
  redirect '/'
end

get '/users/signin' do
  erb :signin
end

post '/users/signin' do
  username = params[:username]
  password = params[:password]

  if valid_credentials?(username, password)
    session[:username] = username
    session[:message] = 'Welcome!'
    redirect '/'
  else
    session[:message] = 'Invalid credentials!'
    status 422
    erb :signin
  end
end

get '/search/' do
  keys = params[:search_query].downcase
  @units = get_unit_or_sc_from_keys(keys)[0]
  @soulcards = get_unit_or_sc_from_keys(keys)[1]
  erb :search
end

get '/' do
  note = File.expand_path('data/maininfo.yml', __dir__)
  @message_note = YAML.load_file(note)
  @units = load_unit_details.to_a.last(3).to_h
  @soulcards = load_soulcards_details.to_a.last(3).to_h
  erb :home
end

get '/basics' do
  path = File.expand_path('data/basics.md', __dir__)
  @markdown = load_file_content(path)
  erb :starterguide
end

get '/download/:filename' do |filename|
  fname = filename
  ftype = 'Application/octet-stream'
  # checked_fname = filename.split('').map(&:to_i).reduce(&:+) == 0
  if filename.include?('soul')
    send_file "./data/sc/#{filename}", filename: fname, type: ftype
  elsif filename.include?('unit') || filename.include?('maininfo') || filename.include?('basics.md')
    send_file "./data/#{filename}", filename: fname, type: ftype
  elsif filename.include?('.jpg')
    send_file "./public/images/sc/#{filename}", filename: fname, type: ftype
  else
    send_file "./public/images/#{filename}", filename: fname, type: ftype
  end
  redirect '/'
end

get '/show_files/:file_name/remove' do
  delete_selected_file(params[:file_name])
  redirect '/show_files'
end

get '/equips/new_sc' do
  @card = load_new_soulcard['new_sc']
  @max_index_val = get_max_index_number(load_soulcards_details)
  erb :new_sc
end

get '/childs/:star_rating/:unit_name' do
  if load_unit_details.include?(params[:unit_name]) == false
    session[:message] = "#{params[:unit_name]} doesn't exist."
    redirect '/'
  end
  @units = load_unit_details
  @unit_name = params[:unit_name].capitalize
  @current_unit = @units[params[:unit_name]]
  erb :view_unit
end

get '/childs/:star_rating/:unit_name/edit' do
  require_user_signin
  @unit_name = params[:unit_name]
  @current_unit = load_unit_details[params[:unit_name]]
  erb :edit_unit
end

get '/equips/:star_rating/:sc_name' do
  @sc_name = params[:sc_name]
  @current_card = load_soulcards_details[params[:sc_name]]
  erb :view_sc
end

get '/equips/:star_rating/:sc_name/edit' do
  require_user_signin
  @card_name = params['sc_name']
  @current_card = load_soulcards_details[params[:sc_name]]
  # name = params[:sc_name]
  erb :edit_sc
end

get '/childs/:star_rating/sort_by/:type' do
  star_rating = params[:star_rating]
  type = params[:type]
  unit_info = load_unit_details
  note = File.expand_path('data/maininfo.yml', __dir__)
  @message_note = YAML.load_file(note)
  @type = type
  if %w[3 4 5].any? { |star| star_rating.include?(star) }
    @sort_catagory_arr = sort_info_by_given_type(unit_info, type)
    @units = sort_by_given_info(unit_info, star_rating, @sort_catagory_arr[1], type)
  else
    session[:message] = 'There are no units by that tier!'
    redirect '/'
  end
  erb :sort_by_type
end

get '/:catagory/:star_rating' do
  star_rating = params[:star_rating]

  if !star_rating == '5stars' ||
     !star_rating == '4stars' ||
     !star_rating == '3stars'
    session[:message] = 'There are no units by that tier!'
    redirect '/'
  end

  if params[:catagory] == 'childs'
    unit_info = load_unit_details
    @catagory = 'childs'
    @units = sort_by_given_info(unit_info, params[:star_rating])
    erb :index_child
  else
    unit_info = load_soulcards_details
    @catagory = 'equips'
    @cards = sort_by_given_info(unit_info, params[:star_rating])
    erb :index_sc
  end
end

get '/show_unit_details' do
  @unit_details = load_unit_details
  @sc_details = load_soulcards_details
  erb :show_unit_details
end

get '/show_files' do
  units = File.join(file_path[0], '*')
  cards = File.join(file_path[1], '*')
  # pattern = File.join(file_path, '*')
  @units = Dir.glob(units).map do |path|
    next if File.directory?(path)

    File.basename(path)
  end
  @soulcards = Dir.glob(cards).map do |path|
    next if File.directory?(path)

    File.basename(path)
  end
  erb :file_list
end

get '/new_unit' do
  require_user_signin
  @new_unit_info = load_new_unit['new_unit']
  @max_index_val = get_max_index_number(load_unit_details)
  erb :new_unit
end

get '/upload' do
  erb :upload
end

post '/equips/new_sc' do
  require_user_signin
  card_data = load_soulcards_details

  @current_unit = load_soulcards_details[params[:sc_name]]
  @max_index_val = get_max_index_number(load_soulcards_details)

  data = load_soulcards_details
  name = params[:sc_name].downcase
  index = params[:index].to_i

  original_card = card_data.select { |unit, info| unit if index == info['index'].to_i }

  pname = create_file_from_upload(params[:file], params[:pic], 'public/images/sc')

  if card_data.include?(name) && index != card_data[name]['index']
    session[:message] = 'A unit by that name already exists. Please create a different card.'
    status 422

    if params['edited']
      temp_name = get_unit_name(card_data, index)
      redirect "/equips/#{params[:stars]}stars/#{temp_name}/edit"
    else
      redirect '/equips/new_sc'
    end

  else
    data.delete(original_card.keys.first)
    data[name] = {}
  end

  data[name]['pic'] = pname.include?('.') ? pname : (pname + '.jpg')
  data[name]['stars'] = params[:stars]
  data[name]['stats'] = params[:stats]
  data[name]['passive'] = params[:passive]
  data[name]['index'] = index

  File.write('data/sc/soul_cards.yml', YAML.dump(data))
  session[:message] = "New Soulcard called #{name.upcase} has been created."
  redirect "/equips/#{params[:stars]}stars/#{name.gsub(' ', '%20')}"
end

post '/new_unit' do
  require_user_signin
  unit_data = load_unit_details
  @current_unit = load_unit_details[params[:unit_name]]
  @max_index_val = get_max_index_number(load_unit_details)

  data = load_unit_details
  name = params[:unit_name].downcase
  index = params[:index].to_i

  original_unit = unit_data.select { |unit, info| unit if params['index'].to_i == info['index'].to_i }

  pname = create_file_from_upload(params[:file], params[:pic], 'public/images')

  if unit_data.include?(name) && index != unit_data[name]['index']
    session[:message] = 'A unit by that name already exists. Please enter a different unit name.'

    status 422

    if params['edited']
      temp_name = get_unit_name(unit_data, index)
      redirect "/childs/#{params[:stars]}stars/#{temp_name}/edit"
    else
      redirect '/new_unit'
    end
  else
    data.delete(original_unit.keys.first)
    data[name] = {}
  end

  data[name]['pic'] = pname.include?('.') ? pname : (pname + '.png')

  data[name]['pic2'] =
    if params[:pic2] == ''
      ''
    elsif params[:pic2].include?('images')
      params[:pic2]
    else
      '/images/' + params[:pic2] + '.png'
    end

  data[name]['pic3'] =
    if params[:pic3] == ''
      ''
    elsif params[:pic3].include?('images')
      params[:pic3]
    else
      '/images/' + params[:pic3] + '.png'
    end

  data[name]['stars'] = params[:stars]
  data[name]['type'] = params[:type]
  data[name]['element'] = params[:element]
  data[name]['tier'] = params[:tier].upcase
  data[name]['leader'] = params[:leader]
  data[name]['auto'] = params[:auto]
  data[name]['tap'] = params[:tap]
  data[name]['slide'] = params[:slide]
  data[name]['drive'] = params[:drive]
  data[name]['notes'] = if params[:notes] != ''
                          params[:notes]
                        else
                          ''
                        end
  data[name]['index'] = index

  File.write('data/unit_details.yml', YAML.dump(data))
  session[:message] = "New unit called #{name.upcase} has been created."
  redirect "/childs/#{params[:stars]}stars/#{name.gsub(' ', '%20')}"
end

get '/childs/:star_rating/:unit_name/remove' do
  require_user_signin
  unit = params[:unit_name]
  units_info = load_unit_details

  if units_info.include?(params[:unit_name]) == false
    status 422
    session[:message] = "That unit doesn't exist."
  else
    units_info.delete(unit)
    File.write('data/unit_details.yml', YAML.dump(units_info))
    session[:message] = 'That unit was successfully deleted.'
  end
  redirect '/'
end

get '/equips/:star_rating/:sc_name/remove' do
  require_user_signin
  card = params[:sc_name]
  cards_info = load_soulcards_details

  if cards_info.include?(params[:sc_name]) == false
    status 422
    session[:message] = "That unit doesn't exist."
  else
    cards_info.delete(card)
    File.write('data/sc/soul_cards.yml', YAML.dump(cards_info))
    session[:message] = 'That unit successfully deleted.'
  end
  redirect '/'
end

# used to upload a file without creating a new unit
post '/upload' do
  require_user_signin
  unless params[:file] &&
         (tmpfile = params[:file][:tempfile]) &&
         (name = params[:file][:filename])
    session[:message] = 'No file selected'
    # return haml(:upload)
    redirect '/upload'
  end

  directory = if name.include?('png')
                file_path[0]
              elsif name.include?('jpg')
                file_path[1]
              elsif ['unit_details.yml', 'maininfo.yml', 'basics.md'].include?(name)
                'data/'
              elsif name == 'soul_cards.yml'
                'data/sc/'
              else

                session[:message] = 'Filename must match original filename'
                redirect '/upload'
              end

  path = File.join(directory, name)
  File.open(path, 'wb') { |f| f.write(tmpfile.read) }
  session[:message] = 'file uploaded!'
  erb :upload
end
