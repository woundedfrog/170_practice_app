require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
require "redcarpet"
require "yaml"
require "nokogiri"
# require "open-uri"
require "fileutils"

helpers do

  def is_special_key?(key)
    ["pic", "tier", "leader", "stars", "type", "element"].include?(key.to_s)
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

def render_markdown(text)
  markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  markdown.render(text)
end

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

get "/" do
  @units = load_unit_details
  @units = @units.sort_by { |k, v| k }.to_h
  erb :index
end

get "/new_unit" do
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
  "file uploaded"
elsif params[:pic]
  pname = params[:pic]
else
    pname = params[:unit_name] + ".jpg"
  end
# ^ this uploads and takes the pic file and processes it.
  if params[:unit_name] == ""
    status 422
    redirect "/#{original_unit.keys.first}/edit"
  elsif unit_data.include?(name) && unit_data[name][params["index"]] != nil
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




    data[name]["pic"] = pname
    data[name]["tier"] = params[:tier]
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

post "/:unit_name/remove" do  #use this if using the form buttons for edit/remove
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

post '/upload' do
  # tempfile = params['file'][:tempfile]
  # filename = params['file'][:filename]
  # File.copy(tempfile.path, "./files/#{filename}")
  # # erb :new_unit
  # redirect "/new_unit"
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
