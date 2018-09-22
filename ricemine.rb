require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
require "redcarpet"
require "yaml"
require "fileutils"
require "bcrypt"

configure do
  set :erb, :escape_html => true
end

configure do
  enable :sessions
  set :session_secret, "secret"
end

helpers do
  def is_special_key?(key)
    ["pic", "pic2", "pic3", "tier", "stars", "type", "element"].include?(key.to_s)
  end

  def format_stat(stat_key, info_val)
    if ['water', 'fire', 'earth', 'light', 'dark'].include?(info_val)
      "<img src='/images/#{info_val}.png'/>"
    elsif  ['tank', 'attacker', 'buffer', 'healer', 'debuffer'].include?(info_val)
      "<img src='/images/#{info_val}.png'/>"
    else
      info_val
    end
  end

  def upcase_name(name)
    name.split(" ").map { |part| part.capitalize  }.join(" ")
  end
end

def delete_selected_file(name)
  Dir.glob("./public/images/").each do |f|

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
  credentials_path = if ENV["RACK_ENV"] == "test"
    File.expand_path("../test/users.yml", __FILE__)
  else
    File.expand_path("../users.yml", __FILE__)
  end
  YAML.load_file(credentials_path)
end

def user_signed_in?
  session.key?(:username)
end

def require_user_signin
  if user_signed_in? == false
    session[:message] = "You must be signed in to do that."
    redirect "/"
  end
end

def file_path
  if ENV["RACK_ENV"] == "test"
    File.expand_path("../test/public/images/", __FILE__)
  else
    File.expand_path("../public/images/", __FILE__)
  end
end

def load_soulcards_details
  unit_list = if ENV["RACK_ENV"] == "test"
    File.expand_path("../test/data/sc/soul_cards.yml", __FILE__)
  else
    File.expand_path("../data/sc/soul_cards.yml", __FILE__)
  end
  YAML.load_file(unit_list)
end

def load_new_soulcard
  unit_list = if ENV["RACK_ENV"] == "test"
    File.expand_path("../test/data/sc/new_soul_card.yml", __FILE__)
  else
    File.expand_path("../data/sc/new_soul_card.yml", __FILE__)
  end
  YAML.load_file(unit_list)
end


def load_new_unit
  unit_list = if ENV["RACK_ENV"] == "test"
    File.expand_path("../test/data/new_unit.yml", __FILE__)
  else
    File.expand_path("../data/new_unit.yml", __FILE__)
  end
  YAML.load_file(unit_list)
end

def load_unit_details
  unit_list = if ENV["RACK_ENV"] == "test"
    File.expand_path("../test/data/unit_details.yml", __FILE__)
  else
    File.expand_path("../data/unit_details.yml", __FILE__)
  end
  YAML.load_file(unit_list)
end

def get_unit_name(data_path, index)
  unit_name = ''
  data_path.each do |name, info|
    if info["index"] == index
      unit_name = name
    end
  end
  unit_name
end

def get_max_index_number(list)
  list.sort_by { |k, v| v["index"] }.to_h
  list = list.map { |k, v| v["index"]}.max + 1
end

def sort_by_given_info(catagory, stars, type = 'name')

  star_rating = stars[0]
  by_stars = catagory.select { |_, v| v["stars"] == star_rating }.to_h

  if type == "name"
    by_stars.sort_by { |k, v| k }.to_h
  elsif type = "tiers"
    by_stars.sort_by { |k, v| v["tier"] }.reverse.to_h
  else
    by_stars.sort_by { |k, v| v[type] }.to_h
  end
end

get "/users/signin" do
  erb :signin
end

post "/users/signin" do
  username = params[:username]
  password = params[:password]

  if valid_credentials?(username, password)
    session[:username] = username
    session[:message] = "Welcome!"
    redirect "/"
  else
    session[:message] = "Invalid credentials!"
    status 422
    erb :signin
  end
end

get "/" do
  units = load_unit_details
  # units = units.select { |_, v| v["stars"] == '5' }.to_h
  # @units = units.sort_by { |k, v| k }.to_h
  erb :home
end

get '/download/:filename' do |filename|
  if filename.include?("soul")
    send_file "./data/sc/#{filename}", :filename => filename, :type => 'Application/octet-stream'
  elsif filename.include?("unit")
    send_file "./data/#{filename}", :filename => filename, :type => 'Application/octet-stream'
  else
    send_file "./public/images/#{filename}", :filename => filename, :type => 'Application/octet-stream'
  end
  redirect "/"
end

get "/show_files/:file_name/remove" do
  delete_selected_file(params[:file_name])
  redirect "/show_files"
end

get "/equips/new_sc" do
  @card = load_new_soulcard["new_sc"]
  @max_index_val = get_max_index_number(load_soulcards_details)
  erb :new_sc
end

get "/childs/:star_rating/:unit_name" do
  if load_unit_details.include?(params[:unit_name]) == false
    session[:message] = "#{params[:unit_name]} doesn't exist."
    redirect "/"
  end
  @units = load_unit_details
  @unit_name = params[:unit_name].capitalize
  @current_unit = @units[params[:unit_name]]
  erb :view_unit
end

get "/childs/:star_rating/:unit_name/edit" do
  require_user_signin
  @current_unit = load_unit_details[params[:unit_name]]
  erb :edit_unit
end

get "/equips/:star_rating/:sc_name" do
  @sc_name = params[:sc_name]
  @current_card = load_soulcards_details[params[:sc_name]]
  name = params[:sc_name]
  erb :view_sc
end

get "/equips/:star_rating/:sc_name/edit" do
  require_user_signin
  @current_card = load_soulcards_details[params[:sc_name]]
  name = params[:sc_name]
  erb :edit_sc
end

get "/:catagory/:star_rating/:type" do
  star_rating = params[:star_rating]
  type = params[:type]
  catagory = params[:catagory] == "childs" ? load_unit_details : load_soulcards_details

  if star_rating.include?("5") || star_rating.include?("4") || star_rating.include?("3")
    @units = sort_by_given_info(catagory, star_rating, type)
  else
    session[:message] = "There are no units by that tier!"
    redirect "/"
  end
  erb :index
end

get "/:catagory/:star_rating" do
  star_rating = params[:star_rating]

  if !star_rating == "5stars" || !star_rating == "4stars" || !star_rating == "3stars"
      session[:message] = "There are no units by that tier!"
      redirect "/"
  end

  if params[:catagory] == "childs"
    unit_info = load_unit_details
    @catagory = 'childs'
    @units = sort_by_given_info(unit_info, params[:star_rating])
    erb :index
  else
    unit_info = load_soulcards_details
    @catagory = 'equips'
    @cards = sort_by_given_info(unit_info, params[:star_rating])
    erb :list_sc
  end
end

get "/show_unit_details" do
  @unit_details = load_unit_details
  @sc_details = load_soulcards_details
  erb :show_unit_details
end

get "/show_files" do
  pattern = File.join(file_path, "*")
  @files = Dir.glob(pattern).map do |path|
    if File.directory?(path)
      next
    else
      File.basename(path)
    end
  end
  erb :file_list
end

get "/new_unit" do
  require_user_signin
  @new_unit_info = load_new_unit["new_unit"]
  @max_index_val = get_max_index_number(load_unit_details)
  erb :new_unit
end

get "/upload" do
  erb :upload
end

get "/childs/:star_rating/:unit_name" do
  if load_unit_details.include?(params[:unit_name]) == false
    session[:message] = "#{params[:unit_name]} doesn't exist."
    redirect "/"
  end
  @units = load_unit_details
  @unit_name = params[:unit_name].capitalize
  @current_unit = @units[params[:unit_name]]
  erb :view_unit
end

get "/childs/:unit_name/edit" do
  require_user_signin
  @current_unit = load_unit_details[params[:unit_name]]
  erb :edit_unit
end

# get "/equips/soulcards" do
#   @cards = load_soulcards_details
#   erb :list_sc
# end



post "/equips/new_sc" do
  require_user_signin
  unit_data = load_soulcards_details
  # @new_card_info = load_new_soulcard["new_sc"]
  @current_unit = load_soulcards_details[params[:sc_name]]
  @max_index_val = get_max_index_number(load_soulcards_details)
  data = load_soulcards_details
  name = params[:sc_name].downcase  #makes sure all names are downcase
  index = params[:index].to_i

  original_unit = unit_data.select {|unit, info| unit if params["index"].to_i == info["index"].to_i}

  # V this uploads and takes the pic file and processes it.
  if params[:file] != nil
    (tmpfile = params[:file][:tempfile]) && (pname = params[:file][:filename])
    directory = "public/images/sc"
    path = File.join(directory, pname)
    File.open(path, "wb") { |f| f.write(tmpfile.read) }
  elsif params[:pic]
    pname = params[:pic]
  else
    pname = params[:sc_name] + ".png"
  end
  pname = "/images/sc/" + pname unless pname.include?("/images/sc/")
  # ^ this uploads and takes the pic file and processes it.

  if unit_data.include?(name) && index != unit_data[name]["index"]
    #this clause makes sure we can only edit units if there are no name conflicts.

    session[:message] = "A unit by that name already exists. Please create a different card."
    if params["edited"]
      status 422
      temp_name = get_unit_name(unit_data, index)
      redirect "/equips/#{temp_name}/edit"
    else
      status 422
      redirect "/equips/new_sc"
    end

  elsif params["edited"] && (unit_data.include?(name) == false && index == original_unit["index"])
    old = data.delete(original_unit.keys.first)
    data[name] = {}
  else
    old = data.delete(original_unit.keys.first)
    data[name] = {}
  end

  data[name]["pic"] = pname.include?(".") ? pname : (pname + ".jpg")
  data[name]["stars"] = params[:stars]
  data[name]["stats"] = params[:stats]
  data[name]["passive"] = params[:passive]
  data[name]["index"] = index

  File.write("data/sc/soul_cards.yml", YAML.dump(data))

  session[:message] = "New Soulcard called #{name.upcase} has been created."
  redirect "/equips/soulcards"
end

post "/new_unit" do
  require_user_signin
  unit_data = load_unit_details
  @current_unit = load_unit_details[params[:unit_name]]
  @max_index_val = get_max_index_number(load_unit_details)
  data = load_unit_details
  name = params[:unit_name].downcase
  index = params[:index].to_i

  original_unit = unit_data.select {|unit, info| unit if params["index"].to_i == info["index"].to_i}

  # V this uploads and takes the pic file and processes it.
  if params[:file] != nil
    (tmpfile = params[:file][:tempfile]) && (pname = params[:file][:filename])
    directory = "public/images"
    path = File.join(directory, pname)
    File.open(path, "wb") { |f| f.write(tmpfile.read) }
  elsif params[:pic]
    pname = params[:pic]
  else
    pname = params[:unit_name]
  end
  pname = "/images/" + pname unless pname.include?("/images/")
  # ^ this uploads and takes the pic file and processes it.

  if unit_data.include?(name) && index != unit_data[name]["index"]
    #this clause makes sure we can only edit units if there are no name conflicts.
    session[:message] = "A unit by that name already exists. Please enter a different unit name."
    if params["edited"]
      status 422
      temp_name = get_unit_name(unit_data, index)
      redirect "/#{temp_name}/edit"
    else
      status 422
      redirect "/new_unit"
    end

  elsif params["edited"] && (unit_data.include?(name) == false && index == original_unit["index"])
    old = data.delete(original_unit.keys.first)
    data[name] = {}
  else
    old = data.delete(original_unit.keys.first)
    data[name] = {}
  end

  data[name]["pic"] = pname.include?(".") ? pname : (pname + ".png")

  if params[:pic2] == ''
    data[name]["pic2"] = ''
  elsif params[:pic2].include?("images")
    data[name]["pic2"] = params[:pic2]
  else
    data[name]["pic2"] = "/images/" + params[:pic2] + ".png"
  end

  if params[:pic3] == ''
    data[name]["pic3"] = ''
  elsif params[:pic3].include?("images")
    data[name]["pic3"] = params[:pic2]
  else
    data[name]["pic3"] = "/images/" + params[:pic3] + ".png"
  end

  data[name]["tier"] = params[:tier].upcase

  data[name]["stars"] = params[:stars]
  data[name]["type"] = params[:type]
  data[name]["element"] = params[:element]
  data[name]["leader"] = params[:leader]
  data[name]["auto"] = params[:auto]
  data[name]["tap"] = params[:tap]
  data[name]["slide"] = params[:slide]
  data[name]["drive"] = params[:drive]
  data[name]["index"] = index

  File.write("data/unit_details.yml", YAML.dump(data))
  session[:message] = "New unit called #{name.upcase} has been created."
  redirect "/"
end

get "/childs/:star_rating/:unit_name/remove" do  #use this if using the normal links for edit/remove
  require_user_signin
  unit = params[:unit_name]
  units_info = load_unit_details

  if units_info.include?(params[:unit_name]) == false
    status 422
    session[:message] = "That unit doesn't exist."
    redirect "/"
  else
    units_info.delete(unit)
    File.write("data/unit_details.yml", YAML.dump(units_info))
    session[:message] = "That unit was successfully deleted."
    redirect "/"
  end
end

get "/equips/:star_rating/:sc_name/remove" do  #use this if using the normal links for edit/remove
  require_user_signin
  card = params[:sc_name]
  cards_info = load_soulcards_details

  if cards_info.include?(params[:sc_name]) == false
    status 422
    session[:message] = "That unit doesn't exist."
    redirect "/equips/soulcards"
  else
    cards_info.delete(card)
    File.write("data/sc/soul_cards.yml", YAML.dump(cards_info))
    session[:message] = "That unit successfully deleted."
    redirect "/equips/soulcards"
  end
end

#used to upload a file without creating a new unit
post '/upload' do
  unless params[:file] &&
    (tmpfile = params[:file][:tempfile]) &&
    (name = params[:file][:filename])
    @error = "No file selected"
    return haml(:upload)
  end
  directory = "public/images"
  path = File.join(directory, name)
  File.open(path, "wb") { |f| f.write(tmpfile.read) }
  session[:message] = "file uploaded!"
  erb :upload
end
