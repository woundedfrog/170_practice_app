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

  def format_stat(info_val)
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

def unit_data_path
  if ENV["RACK_ENV"] == "test"
    File.expand_path("../test/data", __FILE__)
  else
    File.expand_path("../data", __FILE__)
  end
end

def load_unit_details
  unit_list = if ENV["RACK_ENV"] == "test"
    File.expand_path("../test/data/unit_details.yml", __FILE__)
  else
    File.expand_path("../data/unit_details.yml", __FILE__)
  end
  YAML.load_file(unit_list)
end

def get_unit_files(unit)
  profile = ''
  skins = ''
  [profile, skins]
end

def delete_unit(index)
  unit_name = ''
  load_unit_details.each do |name, info|
    if info["index"] == index
      unit_name = name
    end
  end
  unit_name
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
  @new_unit_info = load_unit_details["new_unit"]
  erb :new_unit
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

post "/new_unit" do
  unit_data = load_unit_details
  original_unit = unit_data.select {|unit, info| unit if params["index"].to_i == info["index"].to_i}

  name = params[:unit_name]

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
  # ^ this uploads and takes the pic file and processes it.

  if unit_data.include?(name) && unit_data[name][params["index"]] != nil
    status 422
    redirect "/#{params[:unit_name]}/edit"
  else
    index = unit_data.size
    pname = "/images/" + pname unless pname.include?("/images/")
    data = load_unit_details

    if params["index"] != nil
      index = params["index"].to_i
      old_name = delete_unit(index)
      data[name] = data.delete(old_name)
    else
      data[name] = {}
    end

    data[name]["tier"] = params[:tier]
    data[name]["pic"] = pname
    data[name]["pic2"] = params[:pic2]
    data[name]["pic3"] = params[:pic3]
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
end

get "/:unit_name/remove" do  #use this if using the normal links for edit/remove
  require_user_signin
  unit = params[:unit_name]
  units_info = load_unit_details

  if params[:unit_name] == ""
    status 422
    erb :new_unit
  else
    units_info.delete(unit)
    File.write("data/unit_details.yml", YAML.dump(units_info))
    redirect "/"
  end
end

# post "/:unit_name/remove" do  #use this if using the form buttons for edit/remove
#   unit = params[:unit_name]
#   units_info = load_unit_details
#
#   if params[:unit_name] == ""
#     status 422
#     erb :new_unit
#   else
#     units_info.delete(unit)
#     File.write("data/unit_details.yml", YAML.dump(units_info))
#     redirect "/"
#   end
# end

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
           "file uploaded"
      erb :upload
end
