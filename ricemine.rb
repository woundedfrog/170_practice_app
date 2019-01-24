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

before do
  @message_note = load_file_data('main')
  @units = load_file_data('unit')
  @soulcards = load_file_data('sc')
  @new_unit = load_file_data('new_unit')['new_unit']
  @new_sc = load_file_data('new_sc')['new_sc']
end

helpers do
  def long_stat_key?(key)
    %w[leader auto tap slide drive notes date].include?(key.to_s)
  end

  def short_stat_key?(key)
    %w[tier stars type element].include?(key.to_s)
  end

  def special_key?(key)
    %w[pic pic1 pic2 pic3 index].include?(key.to_s)
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

  def sort_by_and_select_type(unit_info, catagory_type)
    keys = []
    unit_info.each do |_unit_name, unit_details|
      if catagory_type == 'tier'
        unit_details.each do |stat, value|
          next if stat != catagory_type

          keys << value.split(' ').map(&:to_i)
        end
        keys.flatten!
      else
        unit_details.each { |stat, value| keys << value if stat == catagory_type }
      end
    end

    if %w(tier date).include?(catagory_type)
      return keys.uniq.sort.map!(&:to_s).reverse
    end

    keys.uniq.sort.map!(&:to_s)
  end

  def upcase_name(name)
    name.split(' ').map(&:capitalize).join(' ')
  end

  def catagory(idx)
    case idx
    when 0
      'PVE'
    when 1
      'PVP'
    when 2
      'RAID'
    when 3
      'WORLD BOSS'
    end
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

def load_file_data(name)
  case name
  when 'unit'
    load_unit_details
  when 'sc'
    load_soulcards_details
  when 'main'
    note = File.expand_path('data/maininfo.yml', __dir__)
    YAML.load_file(note)
  when 'new_sc'
    load_new_soulcard
  when 'new_unit'
    load_new_unit
  end
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
  indexes = []
  list.each do |unit, stats|
    indexes << stats['index']
  end
  indexes.sort!

  max = indexes.max + 1
  available_indexes = (1..max).to_a - indexes
  # list.sort_by { |_, v| v['index'] }.to_h
  # list.map { |_, v| v['index'] }.max + 1
  available_indexes.min
end

def group_by_catagory_tier(details, catagory_vals)
  groups = [{}, {}, {}, {}]
  groups.size.times do |idx|
    catagory_vals.each do |num|
      details.each do |name, info|
        tiers = info['tier'].split(' ').map(&:to_i)
        groups[idx][num.to_s] = {} if groups[idx][num].nil?
        groups[idx][num][name] = info if tiers[idx] == num.to_s.to_i
      end
    end
  end
  groups
end

def sort_by_given_info(unit_info, stars, catagory_vals = nil, type = nil)
  star_rating = stars[0]
  # units_by_stars = nil
  units_by_stars =
   unit_info.select { |_name, stat| stat['stars'] == star_rating }.to_h

  return group_by_catagory_tier(units_by_stars, catagory_vals) if type == 'tier'

  units_by_stars.sort_by { |name, __stats| name }.to_h
end

def get_unit_or_sc_from_keys(keys)
  cards = @soulcards
  units = @units
  return [nil, nil] if keys.empty?

  unit_results = search_stats_for_key(units, keys)
  card_results = search_stats_for_key(cards, keys)

  [unit_results.to_h, card_results.to_h]
end

def search_stats_for_key(stats, words)
  results = []

  stats.each do |name, info_hash|
    if name.to_s.downcase.include?(words.downcase)
      results << [name, info_hash]
    else
      info_hash.each do |key, val|
        val = val.to_s.downcase
        if val.include?(words) || key.include?(words)
          results << [name, info_hash]
        end
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

# def sort_tier_catagory(tiers_arr, units, index)
#   units.sort_by {|k,v| v['tier'].split(' ')[index]}
# end

def unit_or_sc_exist?(type, name)
  data = if type == 'unit'
           @units
         else
           @soulcards
         end
  if data.include?(name) == false
    session[:message] = "#{name} doesn't exist."
    redirect '/'
  end
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

def check_and_fetch_date(data, name)
  if data.key?(name)
    return data[name]['date'] if data[name].key?('date')
  end
  ''
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
  @units = @units.to_a.last(5).to_h
  @soulcards = @soulcards.to_a.last(3).to_h
  erb :home
end

get '/basics' do
  path = File.expand_path('data/basics.md', __dir__)
  @markdown = load_file_content(path)
  erb :starterguide
end

get "/:filename/edit" do
  file = File.expand_path("data/#{params[:filename]}.yml", __dir__)
  @name = params[:filename]
  @content = YAML.dump(YAML.load_file(file))

  erb :edit_notice
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
  @card = @new_sc
  @max_index_val = get_max_index_number(@soulcards)
  erb :new_sc
end

get '/new_unit' do
  require_user_signin
  @new_unit_info = @new_unit
  @max_index_val = get_max_index_number(@units)
  erb :new_unit
end
 #### remove if double
get '/:catagory/:star_rating' do
  star_rating = params[:star_rating]

  if ![5, 4, 3].include?(star_rating[0].to_i)
    session[:message] = 'There are no units or soulcards by that tier!'
    redirect '/'
  end

  if params[:catagory] == 'childs'
    unit_info = @units
    @catagory = 'childs'
    @units = sort_by_given_info(unit_info, params[:star_rating])
    erb :index_child
  else
    unit_info = @soulcards
    @catagory = 'equips'
    @cards = sort_by_given_info(unit_info, params[:star_rating])
    erb :index_sc
  end
end
####
get '/childs/:star_rating/:unit_name' do
  name = params[:unit_name]
  unit_or_sc_exist?('unit', name)
  @unit_name = name
  @current_unit = @units[name]
  erb :view_unit
end

get '/childs/:star_rating/:unit_name/edit' do
  require_user_signin
  name = params[:unit_name]
  @unit_name = name
  @current_unit = @units[name]
  erb :edit_unit
end

get '/equips/:star_rating/:sc_name' do
  name = params[:sc_name]
  unit_or_sc_exist?('soulcard', name)
  @sc_name = name
  @current_card = @soulcards[name]
  erb :view_sc
end

get '/equips/:star_rating/:sc_name/edit' do
  require_user_signin
  name = params[:sc_name]
  @card_name = name
  @current_card = @soulcards[name]
  erb :edit_sc
end

get '/childs/:star_rating/sort_by/:type' do
  @star_rating = params[:star_rating]
  @catagory_type = params[:type]
  unit_info = @units

  if %w[3 4 5].any? { |star| star == @star_rating[0] }
    @catagories = sort_by_and_select_type(unit_info, @catagory_type)
    @units =
      sort_by_given_info(unit_info, @star_rating, @catagories, @catagory_type)

    return erb :sort_by_tier if @catagory_type == 'tier'
  else
    session[:message] = 'There are no units by that tier!'
    redirect '/'
  end
  erb :sort_by_type
end

get '/show_unit_details' do
  @unit_details = @units
  @sc_details = @soulcards
  erb :show_unit_details
end

get '/show_files' do
  units = File.join(file_path[0], '*')
  cards = File.join(file_path[1], '*')
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

get '/upload' do
  erb :upload
end

post '/equips/new_sc' do
  require_user_signin
  card_data = @soulcards

  @current_unit = card_data[params[:sc_name]]
  @max_index_val = get_max_index_number(card_data)

  data = card_data
  name = params[:sc_name].downcase
  index = params[:index].to_i

  original_card = card_data.select do |unit, info|
    unit if index == info['index'].to_i
  end

  pname = create_file_from_upload(params[:file], params[:pic], 'public/images/sc')

  if card_data.include?(name) && index != card_data[name]['index']
    session[:message] =
      'A card by that name already exists. Please create a different card.'
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
  unit_data = @units

  @current_unit = unit_data[params[:unit_name]]
  @max_index_val = get_max_index_number(unit_data)

  data = unit_data
  name = params[:unit_name].downcase
  index = params[:index].to_i
  date = check_and_fetch_date(data, name)

  original_unit = unit_data.select do |unit, info|
    unit if params['index'].to_i == info['index'].to_i
  end

  pname = create_file_from_upload(params[:file], params[:pic], 'public/images')

  if unit_data.include?(name) && index != unit_data[name]['index']
    session[:message] =
      'A unit by that name already exists. Please enter a different unit name.'
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

  %w(pic2 pic3).each do |param_name|
    data[name][param_name] =
      if params[param_name.to_sym] == ''
        params[param_name.to_sym]
      else
        temp_pic_n = params[param_name.to_sym].gsub('/images/', '').gsub('.png', '')
        '/images/' + temp_pic_n + '.png'
      end
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
  data[name]['notes'] = params[:notes]
  data[name]['date'] = if date == ''
                         new_time = Time.now.utc.localtime('+09:00')
                         [new_time.year, new_time.month, new_time.day].join('-')
                       else
                         date
                       end
  data[name]['index'] = index

  File.write('data/unit_details.yml', YAML.dump(data))
  session[:message] = "New unit called #{name.upcase} has been created."
  redirect "/childs/#{params[:stars]}stars/#{name.gsub(' ', '%20')}"
end

get '/childs/:star_rating/:unit_name/remove' do
  require_user_signin
  unit = params[:unit_name]
  units_info = @units

  if units_info.include?(params[:unit_name]) == false
    status 422
    session[:message] = "That unit doesn't exist."
  else
    units_info.delete(unit)
    File.write('data/unit_details.yml', YAML.dump(units_info))
    session[:message] = "#{unit.upcase} unit was successfully deleted."
  end
  redirect '/'
end

get '/equips/:star_rating/:sc_name/remove' do
  require_user_signin
  card = params[:sc_name]
  cards_info = @soulcards

  if cards_info.include?(params[:sc_name]) == false
    status 422
    session[:message] = "That unit doesn't exist."
  else
    cards_info.delete(card)
    File.write('data/sc/soul_cards.yml', YAML.dump(cards_info))
    session[:message] = "#{card.upcase} SoulCard successfully deleted."
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
    redirect '/upload'
  end

  directory =
    if name.include?('png')
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

post '/update/:filename' do
  name = params[:filename] + '.yml'
  content = params[:content]
  directory =
    if ['unit_details.yml', 'maininfo.yml', 'basics.md'].include?(name)
      session[:message] = "#{name} was updated"
      'data/'
    else
      session[:message] = 'Filename must match original filename'
      redirect '/upload'
    end

  path = File.join(directory, name)
  File.open(path, 'wb') { |f| f.write(content) }
  session[:message] = 'file uploaded!'
  redirect '/'
end
