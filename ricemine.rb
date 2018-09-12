require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
require "redcarpet"
require "yaml"
require "nokogiri"
# require "open-uri"
require "fileutils"

helpers do
#   def full_file_name(file_path)
#     file_path.split("/")
#   end
#
#   def get_file_name(file_path)
#     full_file_name(file_path)[-1]
#   end
#
#   def get_folder_name(file_path)
#     full_file_name(file_path)[-2]
#   end

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

def get_file_name_parts(file)
  file_name = file
  extension = File.extname(file_name) # extract file extension
  basename = File.basename(file_name, extension) # extract file basename
  [basename, extension, file]
end

def get_unit_files(unit)
  profile = ''
  skins = ''
  [profile, skins]
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
    # @new_unit_info = load_unit_details["new_unit"] #used for testing
  erb :unit_view
end

post "/new_unit" do
  @new_unit_info = load_unit_details["new_unit"]
  erb :new_unit
end
