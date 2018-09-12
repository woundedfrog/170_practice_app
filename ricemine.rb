require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
require "redcarpet"
require "yaml"
require "nokogiri"
# require "open-uri"
require "fileutils"

helpers do
  def display_profile_pic(unit)
    data = unit_data_path
    "/"
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
  @title = "Destiny Japan units info"
  @units = load_unit_details
  erb :index
end

get "/new_unit" do
  @new_unit_info = load_unit_details["new_unit"]
  erb :new_unit
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
  @new_unit_info = unit_data["new_unit"]

  name = params[:unit_name]
  pic = params[:pic]

  if params[:unit_name] == ""
    status 422
    erb :new_unit
  elsif unit_data.include?(name) && params["index"] == nil
    status 422
    erb :new_unit
  else
    index = unit_data.size
    pic = "/images/" + pic unless pic.include?("/images/")
    data = load_unit_details

    if params["index"] != nil
      index = params["index"].to_i
      old_name = delete_unit(index)
      data[name] = data.delete(old_name)
    else
      data[name] = {}
    end

    data[name]["pic"] = pic
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

post "/:unit_name/remove" do
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
