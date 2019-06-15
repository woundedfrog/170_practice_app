ENV["RACK_ENV"] = 'test'

# require "fileutils"
require 'minitest/autorun'
require 'minitest/reporters'
require 'rack/test'
require 'yaml'
Minitest::Reporters.use!

require_relative '../ricemine'

class RiceMineTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup

    FileUtils.mkdir_p("../test/data/")
    FileUtils.mkdir_p("../test/data/sc/")
    FileUtils.mkdir_p("../test/public/images/")
    FileUtils.mkdir_p("../test/public/images/sc/")

    new_unit = {"new_name" => {"pic" => "", "pic2" => "", "pic3" => "", "tier" => "", "stars" => '', "element" => "", "type" => "", "leader" => '', "tap" => '', "auto" => '', "slide" => '', "drive" => '', "notes" => '', "date" => '', "index" => 0}}

    units = {"cleopatra" => {"pic" => "cleopatra0.png", "pic2" => "", "pic3" => "", "tier" => "s", "stars" => "5", "element" => "light", "type" => "attacker", "leader" => '', "tap" => '', "auto" => '', "slide" => '', "drive" => '', "notes" => '', "date" => '', "index" => 0, 'enabled' => 'true'},
    "dana" => {"pic" => "dana0.png", "pic2" => "", "pic3" => "", "tier" => "s", "stars" => "5", "element" => "light", "type" => "tank", "leader" => '', "tap" => '', "auto" => '', "slide" => '', "drive" => '', "notes" => '', "date" => '', "index" => 1, 'enabled' => 'true'},
    "maat" => {"pic" => "maat0.png", "pic2" => "", "pic3" => "", "tier" => "s", "stars" => "5", "element" => "light", "type" => "healer", "leader" => '', "tap" => '', "auto" => '', "slide" => '', "drive" => '', "notes" => '', "date" => '', "index" => 2, 'enabled' => 'true'}}

    new_sc = {"new_sc" => { "pic" => "", "stars" => '5', "stats" => "", "passive" => "", "index"=> 0}}

    sc = {"vacation" => { "pic" => "vacation0.jpg", "stars" => '5', "stats" => "", "passive" => "", "index"=> 0}}

    create_unit_file("new_unit.yml", new_unit)
    create_unit_file("unit_details.yml", units)
    create_soulcard_file("new_soul_card.yml", new_sc)
    create_soulcard_file("soul_cards.yml", sc)
  end

  def session
    last_request.env["rack.session"]
  end

  def admin_session
    { "rack.session" => { username: "mnyiaa"} }
  end

  def create_unit_file(name, content = "")
    File.open(File.join("../test/data/", name), "w") do |file|
      File.write(file, YAML.dump(content))
    end
  end

  def create_soulcard_file(name, content = "")
    File.open(File.join("../test/data/sc/", name), "w") do |file|
      File.write(file, YAML.dump(content))
    end
  end

  def create_file(path, extension)
    dir = File.dirname(path)

    unless File.directory?(dir)
      FileUtils.mkdir_p(dir)
    end

    path << ".#{extension}"
    File.new(path, 'w')
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
  # def create_unit(name, content = "")
  #   File.write("../test/data/unit_details.yml", YAML.dump(content))
  # end

  # def create_soulcard(name, content = "")
  #   File.write("../test/data/sc/unit_details.yml", YAML.dump(content))
  # end

  def test_index_page
    get "/"
    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_includes last_response.body, "Recent"
    assert_includes last_response.body, "Dana"
    assert_includes last_response.body, "Maat"
  end

  def test_show_unit_details_list
    get "/show_unit_details"
    assert_includes last_response.body, *["Their names are:", "Get unit details"]
    assert_includes last_response.body, "Get soulcard details"
    assert_includes last_response.body, "There are 3 units"
  end

  def test_file_paths
    assert_equal load_new_unit.class, {}.class
    assert_equal load_unit_details.class, {}.class
    assert_equal load_soulcards_details.class, {}.class
  end

  def test_units_info
    details = load_unit_details
    assert_includes details, "cleopatra"

    assert_equal details["cleopatra"]["stars"], '5'
    assert_equal details["cleopatra"]["type"], 'attacker'

    get "/childs/5stars/cleopatra"
    assert_includes last_response.body, "attacker"
    assert_includes last_response.body, "attacker"
  end

  def test_sc_info
    details = load_soulcards_details
    assert_includes details, "vacation"

    assert_equal details["vacation"]["stars"], '5'
    get "/equips/5stars/vacation"
    assert_includes last_response.body, "Passive"
  end

  def test_view_profile
    get "/childs/5stars/cleopatra"
    assert_equal last_response.status, 200
    assert_includes last_response.body, *["<h3>Cleopatra", "profile_imgs"]
    assert_includes last_response.body, *["<button", "Drive"]
  end

  def test_unit_profile_not_found
    get "/childs/5stars/invalid_unit_name"

    assert_equal 302, last_response.status
    assert_equal "invalid_unit_name doesn't exist.", session[:message]

    get "/childs/4stars/invalid_unit_name"

    assert_equal 302, last_response.status
    assert_equal "invalid_unit_name doesn't exist.", session[:message]
  end

  def test_unit_editing_signed_in
    # with signing in -> no error
    get "/childs/5stars/cleopatra/edit", {}, admin_session
    assert_equal 200, last_response.status
    assert_includes last_response.body, "<input"
    assert_includes last_response.body, %q(<input name="edited" type="checkbox" required>)
  end

  def test_unit_editing_signed_out
    # without signing in -> error
    get "/childs/5stars/cleopatra/edit"
    assert_equal 302, last_response.status
    assert_equal "You must be signed in to do that.", session[:message]
  end

  def test_editing_updating_unit
    get "/childs/5stars/cleopatra/edit", {:current_unit_name => "cleopatra"}, admin_session
    assert_includes last_response.body, "cleopatra"

    post "/new_unit", {:current_unit_name => "cleopatra", :new_unit_name => "cleopatra1", :tier => "S", :pic => '', :pic2 => '', :pic3 => '', :index => 0}, admin_session

    assert_equal "New unit called CLEOPATRA1 has been created.", session[:message]

    assert_equal 302, last_response.status
    assert_equal load_unit_details.keys.size, 3
    assert_includes load_unit_details.keys, "cleopatra1"
    refute_includes load_unit_details.keys, "cleopatra0"
  end

  def test_editing_updating_unit_and_redirect
    post "/new_unit", {:new_unit_name => "cleopatra1", :tier => "S", :pic => '', :pic2 => '', :pic3 => '', :stars => 5, :slide => '', :tap => '', :drive => '', :leader => '', :auto => '', :notes => '', :index => 0}, admin_session

    assert_equal 302, last_response.status
    assert_equal "New unit called CLEOPATRA1 has been created.", session[:message]

    get last_response["location"]
    assert_includes last_response.body, *["<h3>Cleopatra1", "profile_imgs"]
  end

  def test_creating_new_unit
    # img_file = "file" => Rack::Test::UploadedFile.new("testunit.png", "image/png")

    post "/new_unit", {:new_unit_name => "eve", :tier => "S", "file" => Rack::Test::UploadedFile.new("testunit.png", "image/png"), :pic2 => '', :pic3 => '', :index => 3}, admin_session


    assert_equal "New unit called EVE has been created.", session[:message]
    assert_equal 302, last_response.status
    assert_equal load_unit_details.keys.size, 4
    assert_includes load_unit_details.keys, "eve"
    assert_includes load_unit_details["eve"]["pic"], "images/testunit.png"

  end

  def test_updating_soulcard
    get "/equips/5stars/vacation/edit", {:unit_name => "vacation"}, admin_session
    assert_includes last_response.body, "vacation"

    post "/equips/new_sc", {:sc_name => "vacation2", :pic => '', :index => 0}, admin_session

    assert_equal "New Soulcard called VACATION2 has been created.", session[:message]

    assert_equal 302, last_response.status
    assert_equal load_soulcards_details.keys.size, 1
    assert_includes load_soulcards_details.keys, "vacation2"
    refute_includes load_soulcards_details.keys, "vacation"
  end

  def test_creating_new_soulcard
    post "/equips/new_sc", {:sc_name => "vacation2", "file" => Rack::Test::UploadedFile.new("testsc.jpg", "image/jpg"), :index => 1}, admin_session


    assert_equal "New Soulcard called VACATION2 has been created.", session[:message]
    assert_equal 302, last_response.status
    assert_equal load_soulcards_details.keys.size, 2
    assert_includes load_soulcards_details.keys, "vacation2"
    assert_includes load_soulcards_details["vacation2"]["pic"], "images/sc/testsc.jpg"
  end

  def test_view_new_unit_form
    get "/equips/new_sc", {"new_name" => {"pic" => "", "pic2" => "", "pic3" => "", "tier" => "", "stars" => '', "element" => "", "type" => "", "leader" => '', "tap" => '', "auto" => '', "slide" => '', "drive" => '', "index" => 0}}, admin_session

    assert_equal 200, last_response.status

    assert_includes last_response.body, "<input"
    assert_includes last_response.body, %q(<button type="submit")
  end

  def test_view_new_soulcard_form
    get "/equips/new_sc", {:new_sc => { :pic => "", :stars => '5', :stats => "", :passive => "", :index=> 0}}, admin_session
  # {:unit_name => "eve", :index => 1},
    assert_equal 200, last_response.status

    assert_includes last_response.body, "<input"
    assert_includes last_response.body, %q(<button type="submit")
  end

  def test_view_new_unit_form_signed_out
    get "/new_unit"

    assert_equal 302, last_response.status
    assert_equal "You must be signed in to do that.", session[:message]
  end

  def test_creating_new_unit_signed_out
    post "/new_unit", {:unit_name => "eve", :tier => "S", :pic2 => '', :pic3 => '', :index => 3}


    assert_equal "You must be signed in to do that.", session[:message]
    assert_equal 302, last_response.status
    # assert_equal load_unit_details.keys.size, 3
    refute_includes load_unit_details.keys, "eve"
  end

  def test_deleting_unit
    get "/childs/5stars/cleopatra", {:unit_name => "cleopatra"}
    assert_equal 200, last_response.status

    get "/childs/5stars/cleopatra/remove", {}, admin_session
    assert_equal 302, last_response.status
    assert_equal "CLEOPATRA unit was successfully deleted.", session[:message]

    get "/"
    refute_includes last_response.body, "Cleopatra"
  end

  def test_deleting_document_signed_out
    get "/childs/5stars/cleopatra/remove"
    assert_equal 302, last_response.status
    assert_equal "You must be signed in to do that.", session[:message]
  end

  def test_removing_image_file

  end

  def test_uploading_files
    post "/upload", {"file" => Rack::Test::UploadedFile.new("testunit.png", "image/png")}, admin_session

    assert_equal last_response.status, 200
    assert_includes last_response.body, "file uploaded"

    post "/upload", {"file" => Rack::Test::UploadedFile.new("testsc.jpg", "image/jpg")}, admin_session

    assert_equal last_response.status, 200
    assert_includes last_response.body, "file uploaded"
  end

  def test_uploading_file_with_no_file_selected
    post "/upload", {}, admin_session

    assert_equal last_response.status, 302
    get last_response["Location"]
    assert_includes last_response.body, "No file selected"
  end

  def test_search_for_keywords
    get '/search?search_query=attacker'

    assert_equal 200, last_response.status
    assert_includes last_response.body, "Cleopatra"

    get '/search?search_query=heal'

    assert_equal 200, last_response.status
    assert_includes last_response.body, "Maat"
  end

  def test_signin_form
    get "/users/signin"

    assert_equal 200, last_response.status
    assert_includes last_response.body, "<input"
    assert_includes last_response.body, %q(<button type="submit")
  end

  def test_signin
    post "/users/signin", username: "mnyiaa", password: "thiccissick"
    assert_equal 302, last_response.status
    assert_equal "Welcome!", session[:message]
    assert_equal "mnyiaa", session[:username]

    get last_response["Location"]
    assert_includes last_response.body, "Welcome!"
  end

  def test_signin_with_bad_credentials
    post "/users/signin", username: "guest", password: "shhhh"
    assert_equal 422, last_response.status
    assert_nil session[:username]
    assert_includes last_response.body, "Invalid credentials"
  end

  def test_index_as_signed_in_user
    get "/", {}, {"rack.session" => { username: "mnyiaa"} }
  end

  def test_downloading_files
    get "/download/unit_details.yml"
    assert_equal 200, last_response.status

    get "/download/soul_cards.yml"
    assert_equal 200, last_response.status
  end

  def teardown
        FileUtils.rm_rf("../test/data")
        FileUtils.rm_rf("../test/public")
  end
end
