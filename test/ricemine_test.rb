ENV["RACK_ENV"] = "test"

# require "fileutils"
require "minitest/autorun"
require 'minitest/reporters'
require "rack/test"
require 'yaml'
Minitest::Reporters.use!

require_relative "../ricemine"

class RiceMineTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup

    FileUtils.mkdir_p("../test/data/")
    FileUtils.mkdir_p("../test/data/sc/")

    new_unit = {"new_name" => {"pic" => "", "pic2" => "", "pic3" => "", "tier" => "", "stars" => '', "element" => "", "type" => "", "leader" => '', "tap" => '', "auto" => '', "slide" => '', "drive" => '', "index" => 0}}

    units = {"cleopatra" => {"pic" => "cleopatra0.png", "pic2" => "", "pic3" => "", "tier" => "s", "stars" => "5", "element" => "light", "type" => "attacker", "leader" => '', "tap" => '', "auto" => '', "slide" => '', "drive" => '', "index" => 0},
    "dana" => {"pic" => "cleopatra0.png", "pic2" => "", "pic3" => "", "tier" => "s", "stars" => "5", "element" => "light", "type" => "tank", "leader" => '', "tap" => '', "auto" => '', "slide" => '', "drive" => '', "index" => 1}}

    new_sc = {"new_sc" => { "pic" => "", "stars" => '5', "stats" => "", "passive" => "", "index"=> 0}}

    sc = {"vacation" => { "pic" => "vacation0.jpg", "stars" => '5', "stats" => "", "passive" => "", "index"=> 0}}

    create_unit_file("new_unit.yml", new_unit)
    # create_file("new_unit.yml", units)
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
    assert_includes last_response.body, "cleopatra"
  end

  def test_show_unit_details_list
    get "/show_unit_details"
    assert_includes last_response.body, *["Their names are:", "Get unit details"]
    assert_includes last_response.body, "Get soulcard details"
    assert_includes last_response.body, "There are 2 units"
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

    get "/cleopatra"
    assert_includes last_response.body, "attacker"
    assert_includes last_response.body, "attacker"
  end

  def test_sc_info
    details = load_soulcards_details
    assert_includes details, "vacation"

    assert_equal details["vacation"]["stars"], '5'
    get "/equips/soulcards/vacation"
    assert_includes last_response.body, "Passive"
  end

  def test_unit_profile_not_found
    get "/invalid_unit_name"

    assert_equal 302, last_response.status
    assert_equal "invalid_unit_name doesn't exist.", session[:message]
  end

  def test_unit_editing_signed_in
    # with signing in -> no error
    get "/cleopatra/edit", {}, admin_session
    assert_equal 200, last_response.status
    assert_includes last_response.body, "<input"
    assert_includes last_response.body, %q(<input name="edited" type="checkbox" required>)
  end

  def test_unit_editing_signed_out
    # without signing in -> error
    get "/cleopatra/edit"
    assert_equal 302, last_response.status
    assert_equal "You must be signed in to do that.", session[:message]
  end

  def test_editing_updating_unit
    get "/cleopatra/edit", {:unit_name => "cleopatra"}, admin_session
    assert_includes last_response.body, "cleopatra"

    post "/new_unit", {:unit_name => "cleopatra1", :tier => "S", :pic2 => '', :pic3 => ''}, admin_session

    assert_equal "New unit called CLEOPATRA1 has been created.", session[:message]

    assert_equal 302, last_response.status
    assert_equal load_unit_details.keys.size, 2
    assert_includes load_unit_details.keys, "cleopatra1"
    refute_includes load_unit_details.keys, "cleopatra0"
  end

  def test_creating_new_unit
    post "/new_unit", {:unit_name => "eve", :tier => "S", :pic2 => '', :pic3 => '', :index => 3}, admin_session


    assert_equal "New unit called EVE has been created.", session[:message]
    assert_equal 302, last_response.status
    assert_equal load_unit_details.keys.size, 3
    assert_includes load_unit_details.keys, "eve"
  end

  def test_updating_soulcard
    get "/equips/vacation/edit", {:unit_name => "vacation"}, admin_session
    assert_includes last_response.body, "vacation"

    post "/equips/new_sc", {:sc_name => "vacation2"}, admin_session

    assert_equal "New Soulcard called VACATION2 has been created.", session[:message]

    assert_equal 302, last_response.status
    assert_equal load_soulcards_details.keys.size, 1
    assert_includes load_soulcards_details.keys, "vacation2"
    refute_includes load_soulcards_details.keys, "vacation"
  end

  def test_creating_new_soulcard
    post "/equips/new_sc", {:sc_name => "vacation2", :index => 1}, admin_session


    assert_equal "New Soulcard called VACATION2 has been created.", session[:message]
    assert_equal 302, last_response.status
    assert_equal load_soulcards_details.keys.size, 2
    assert_includes load_soulcards_details.keys, "vacation2"
  end

  def test_view_new_unit_form
    get "/equips/new_sc", {"new_name" => {"pic" => "", "pic2" => "", "pic3" => "", "tier" => "", "stars" => '', "element" => "", "type" => "", "leader" => '', "tap" => '', "auto" => '', "slide" => '', "drive" => '', "index" => 0}}, admin_session
  # {:unit_name => "eve", :index => 1},
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
#
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
    get "/cleopatra", {:unit_name => "cleopatra"}
    assert_equal 200, last_response.status

    get "/cleopatra/remove", {}, admin_session
    assert_equal 302, last_response.status
    assert_equal "That unit was successfully deleted.", session[:message]

    #
    get "/"
    refute_includes last_response.body, "Cleopatra"
  end

  def test_deleting_document_signed_out
    get "/cleopatra/remove"
    assert_equal 302, last_response.status
    assert_equal "You must be signed in to do that.", session[:message]
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

#   def test_signout
#     get "/", {}, {"rack.session" => { username: "admin"} }
#     assert_includes last_response.body, "Signed in as admin"
#
#     post "/users/signout"
#     get last_response["Location"]
#
#     assert_nil session[:username]
#     assert_includes last_response.body, "You have been signed out"
#     assert_includes last_response.body, "Sign In"
#   end

# # These two tests are doing the same thing, but the 2nd one is more natural.
#   def test_sets_session_value
#     post "/users/signin", username: "admin", password: "secret"
#     get last_response["Location"]
#
#     get "/"
#     assert_equal "admin", session[:username]
#   end

  def test_index_as_signed_in_user
    get "/", {}, {"rack.session" => { username: "mnyiaa"} }
  end

  def teardown
        FileUtils.rm_rf("../test/data")
  end
end