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

  def format_stat(_stat_key, info_val)
    if %w[water fire earth light dark].include?(info_val)
      "<img class=\'element-type-pic\' src='/images/#{info_val}.png'/>"
    elsif %w[tank attacker buffer healer debuffer].include?(info_val)
      "<img class=\'element-type-pic\' src='/images/#{info_val}.png'/>"
    else
      info_val
    end
  end

  def sort_info_by_given_type(criteria, type)
    keys = []
    criteria.values.each do |hash|
      hash.each do |k, v|
        keys << v if k == type
      end
    end

    if type == 'tier'
      keys.uniq!.sort!
      [type, [keys[-1]] + keys[0..-2]]
    else
      [type, keys.uniq.sort]
    end
  end

  def upcase_name(name)
    name.split(' ').map(&:capitalize).join(' ')
  end
end

def delete_selected_file(name)
  Dir.glob('./public/images/').each do |f|
    FileUtils.rm(f + name)
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
  if ENV['RACK_ENV'] == 'test'
    File.expand_path('test/public/images/', __dir__)
  else
    File.expand_path('public/images/', __dir__)
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
  list.sort_by { |_, v| v['index'] }.to_h
  list.map { |_, v| v['index'] }.max + 1
end

def sort_by_given_info(catagory, stars)
  star_rating = stars[0]
  by_stars = catagory.select { |_, v| v['stars'] == star_rating }.to_h

  by_stars.sort_by { |k, _| k }.to_h
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

get '/' do
  # units = units.select { |_, v| v['stars'] == '5' }.to_h
  # @units = units.sort_by { |k, v| k }.to_h
  @units = load_unit_details.to_a[-3..-1].to_h
  @soulcards = load_soulcards_details.to_a[-3..-1].to_h
  erb :home
end

get '/download/:filename' do |filename|
  fname = filename
  ftype = 'Application/octet-stream'
  if filename.include?('soul')
    send_file "./data/sc/#{filename}", filename: fname, type: ftype
  elsif filename.include?('unit')
    send_file "./data/#{filename}", filename: fname, type: ftype
  else
    send_file "./public/images/#{filename}",  filename: fname, type: ftype
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
  @current_unit = load_unit_details[params[:unit_name]]
  erb :edit_unit
end

get '/equips/:star_rating/:sc_name' do
  @sc_name = params[:sc_name]
  @current_card = load_soulcards_details[params[:sc_name]]
  # name = params[:sc_name]
  erb :view_sc
end

get '/equips/:star_rating/:sc_name/edit' do
  require_user_signin
  @current_card = load_soulcards_details[params[:sc_name]]
  # name = params[:sc_name]
  erb :edit_sc
end

get '/childs/:star_rating/sort_by/:type' do
  star_rating = params[:star_rating]
  type = params[:type]
  catagory = load_unit_details

  if star_rating.include?('5') ||
     star_rating.include?('4') ||
     star_rating.include?('3')
    @sort_catagory = sort_info_by_given_type(catagory, type)
    @units = sort_by_given_info(catagory, star_rating)
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
  pattern = File.join(file_path, '*')
  @files = Dir.glob(pattern).map do |path|
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

# get '/childs/:star_rating/:unit_name' do
#   if load_unit_details.include?(params[:unit_name]) == false
#     session[:message] = "#{params[:unit_name]} doesn't exist."
#     redirect '/'
#   end
#   @units = load_unit_details
#   @unit_name = params[:unit_name].capitalize
#   @current_unit = @units[params[:unit_name]]
#   erb :view_unit
# end

# get '/childs/:unit_name/edit' do
#   require_user_signin
#   @current_unit = load_unit_details[params[:unit_name]]
#   erb :edit_unit
# end

# get '/equips/soulcards' do
#   @cards = load_soulcards_details
#   erb :index_sc
# end

post '/equips/new_sc' do
  require_user_signin
  card_data = load_soulcards_details

  @current_unit = load_soulcards_details[params[:sc_name]]
  @max_index_val = get_max_index_number(load_soulcards_details)

  data = load_soulcards_details
  name = params[:sc_name].downcase
  index = params[:index].to_i

  original_card = card_data.select { |unit, info| unit if params['index'].to_i == info['index'].to_i }

  # V this uploads and takes the pic file and processes it.
  if !params[:file].nil?
    (tmpfile = params[:file][:tempfile]) && (pname = params[:file][:filename])
    directory = 'public/images/sc'
    path = File.join(directory, pname)
    File.open(path, 'wb') { |f| f.write(tmpfile.read) }
  elsif params[:pic]
    pname = params[:pic]
  else
    pname = params[:sc_name] + '.png'
  end
  pname = '/images/sc/' + pname unless pname.include?('/images/sc/')
  # ^ this uploads and takes the pic file and processes it.

  if card_data.include?(name) && index != card_data[name]['index']
    # this clause makes sure we can only edit units if no name conflicts.

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
  # redirect "/equips/#{params[:stars]}stars"
  redirect '/'
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

  # V this uploads and takes the pic file and processes it.
  if !params[:file].nil?
    (tmpfile = params[:file][:tempfile]) && (pname = params[:file][:filename])
    directory = 'public/images'
    path = File.join(directory, pname)
    File.open(path, 'wb') { |f| f.write(tmpfile.read) }
  elsif params[:pic]
    pname = params[:pic]
  else
    pname = params[:unit_name]
  end
  pname = '/images/' + pname unless pname.include?('/images/')
  # ^ this uploads and takes the pic file and processes it.

  if unit_data.include?(name) && index != unit_data[name]['index']
    # this clause makes sure we can only edit units if no name conflicts.
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

  data[name]['tier'] = params[:tier].upcase

  data[name]['stars'] = params[:stars]
  data[name]['type'] = params[:type]
  data[name]['element'] = params[:element]
  data[name]['leader'] = params[:leader]
  data[name]['auto'] = params[:auto]
  data[name]['tap'] = params[:tap]
  data[name]['slide'] = params[:slide]
  data[name]['drive'] = params[:drive]
  data[name]['index'] = index

  File.write('data/unit_details.yml', YAML.dump(data))
  session[:message] = "New unit called #{name.upcase} has been created."
  # redirect "/childs/#{params[:stars]}stars"
  redirect '/'
end

# use this if using the normal links for edit/remove
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

# use this if using the normal links for edit/remove
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
  unless params[:file] &&
         (tmpfile = params[:file][:tempfile]) &&
         (name = params[:file][:filename])
    @error = 'No file selected'
    return haml(:upload)
  end
  directory = 'public/images'
  path = File.join(directory, name)
  File.open(path, 'wb') { |f| f.write(tmpfile.read) }
  session[:message] = 'file uploaded!'
  erb :upload
end
