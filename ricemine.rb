require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
require "redcarpet"
require "yaml"
require "nokogiri"
require "fileutils"
require "bcrypt"

configure do
  enable :sessions
  set :session_secret, "secret"
end

helpers do
  def is_special_key?(key)
    ["pic", "pic2", "pic3", "tier", "leader", "stars", "type", "element"].include?(key.to_s)
  end

  def format_stat(stat_key, info_val)
   if ['water', 'fire', 'earth', 'light', 'dark'].include?(info_val)
      "<img src='/images/#{info_val}.png' style='width:25%; padding-left: 0em;display:block; margin-right: auto;margin-left: 25%;'/>"
    elsif  ['defensive', 'offensive', 'support', 'healing', 'restraint'].include?(info_val)
      "<img src='/images/#{info_val}.png' style='width:30%; padding-left: 0em;display:block; margin-right: auto;margin-left: 25%;'/>"
    else
      info_val
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
# def render_markdown(text)
#   markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
#   markdown.render(text)
# end

# def unit_data_path
#   if ENV["RACK_ENV"] == "test"
#     File.expand_path("../test/data/", __FILE__)
#   else
#     File.expand_path("../data/", __FILE__)
#   end
# end

def soulcards_data_path
  unit_list = if ENV["RACK_ENV"] == "test"
    File.expand_path("../test/data/sc/soul_cards.yml", __FILE__)
  else
    File.expand_path("../data/sc/soul_cards.yml", __FILE__)
  end
  YAML.load_file(unit_list)
end

def new_soulcards_data_path
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

# def get_unit_files(unit)
#   profile = ''
#   skins = ''
#   [profile, skins]
# end

def get_unit_name(index)
  unit_name = ''
  load_unit_details.each do |name, info|
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
  @units = load_unit_details
  @units = @units.sort_by { |k, v| k }.to_h
  erb :index
end

get "/sort_by/:type" do
  @units = load_unit_details
  @units = @units.sort_by { |k, v| v[params[:type]] }.to_h
  erb :index
end

get "/new_unit" do
  require_user_signin
  @new_unit_info = load_new_unit["new_unit"]
  @max_index_val = get_max_index_number(load_unit_details)
  erb :new_unit
end

get "/equips/new_sc" do
  @card = new_soulcards_data_path["new_sc"]
  @max_index_val = get_max_index_number(soulcards_data_path)
  erb :new_sc
end

get "/upload" do
  erb :upload
end

get "/:unit_name" do
  @units = load_unit_details
  @current_unit = @units[params[:unit_name]]
  erb :unit_view
end

get "/:unit_name/edit" do
  require_user_signin
  @current_unit = load_unit_details[params[:unit_name]]
  erb :edit_unit
end

get "/equips/soulcards" do
  @cards = soulcards_data_path
  erb :sc_list
end

get "/equips/soulcards/:sc_name" do
  @current_card = soulcards_data_path[params[:sc_name]]
  name = params[:sc_name]
  erb :view_sc
end

get "/equips/:sc_name/edit" do
  @current_card = soulcards_data_path[params[:sc_name]]
  name = params[:sc_name]
  erb :sc_edit
end

post "/equips/new_sc" do
  unit_data = soulcards_data_path
  @new_unit_info = new_soulcards_data_path["new_sc"]
  @current_unit = soulcards_data_path[params[:unit_name]]
  @max_index_val = get_max_index_number(soulcards_data_path)
  data = soulcards_data_path
  name = params[:unit_name]
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
    pname = params[:unit_name] + ".jpg"
  end
  pname = "/images/sc/" + pname unless pname.include?("/images/sc/")
  # ^ this uploads and takes the pic file and processes it.

  if unit_data.include?(name) && index != unit_data[name]["index"]
    #this clause makes sure we can only edit units if there are no name conflicts.

    session[:message] = "A unit by that name already exists. Please enter a different unit name."
    if params["edited"]
        status 422
        redirect "/#{params[:unit_name]}/edit"
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

  # V this uploads and takes the pic file and processes it.
  if params[:file] != nil
    (tmpfile = params[:file][:tempfile]) && (pname = params[:file][:filename])
    directory = "public/images/sc"
    path = File.join(directory, pname)
    File.open(path, "wb") { |f| f.write(tmpfile.read) }
  elsif params[:pic]
    pname = params[:pic]
  else
    pname = params[:unit_name] + ".jpg"
  end
  pname = "/images/sc/" + pname unless pname.include?("/images/sc/")
  # ^ this uploads and takes the pic file and processes it.

    data[name]["pic"] = (pname += ".jpg")
    data[name]["stars"] = params[:stars]
    data[name]["stats"] = params[:stats]
    data[name]["passive"] = params[:passive]
    data[name]["index"] = index

    File.write("data/sc/soul_cards.yml", YAML.dump(data))
    redirect "/equips/soulcards"
end

post "/new_unit" do
  unit_data = load_unit_details
  @new_unit_info = load_new_unit["new_unit"]
  @current_unit = load_unit_details[params[:unit_name]]
  @max_index_val = get_max_index_number(load_unit_details)
  data = load_unit_details
  name = params[:unit_name]
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
    pname = params[:unit_name] + ".jpg"
  end
  pname = "/images/" + pname unless pname.include?("/images/")
  # ^ this uploads and takes the pic file and processes it.

  if unit_data.include?(name) && index != unit_data[name]["index"]
    #this clause makes sure we can only edit units if there are no name conflicts.

    session[:message] = "A unit by that name already exists. Please enter a different unit name."
    if params["edited"]
        status 422
        redirect "/#{params[:unit_name]}/edit"
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

  # V this uploads and takes the pic file and processes it.
  if params[:file] != nil
    (tmpfile = params[:file][:tempfile]) && (pname = params[:file][:filename])
    directory = "public/images"
    path = File.join(directory, pname)
    File.open(path, "wb") { |f| f.write(tmpfile.read) }
  elsif params[:pic]
    pname = params[:pic]
  else
    pname = params[:unit_name] + ".jpg"
  end
  pname = "/images/" + pname unless pname.include?("/images/")
  # ^ this uploads and takes the pic file and processes it.

    data[name]["tier"] = params[:tier]
    data[name]["pic"] = (pname += ".jpg")
    data[name]["pic2"] = params[:pic2].include?("/images/") ? params[:pic2] : "/images/" + params[:pic2]
    data[name]["pic3"] =  params[:pic3].include?("/images/") ? params[:pic3] : "/images/" + params[:pic3]
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
    redirect "/"
end

get "/:unit_name/remove" do  #use this if using the normal links for edit/remove
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
    session[:message] = "That unit successfully deleted."
    redirect "/"
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
