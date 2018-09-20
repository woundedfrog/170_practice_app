ENV["RACK_ENV"] = "test"

require "fileutils"
require "minitest/autorun"
require "rack/test"

require_relative "../ricemine"

class RICEMINETest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup

    FileUtils.mkdir_p("../test/data/")
    FileUtils.mkdir_p("../test/data/sc/")
    # @unit_details = load_unit_details
    # @card_details = load_soulcards_details
    # @new_unit = load_unit_details
    new_unit = {"new_name" => {"pic" => "", "pic2" => "", "pic3" => "", "tier" => "", "stars" => '', "element" => "", "type" => "", "leader" => '', "tap" => '', "auto" => '', "slide" => '', "drive" => '', "index" => 0}}

    units = {"dana" => {"pic" => "dana0.png", "pic2" => "", "pic3" => "","tier" => "s", "stars" => "5", "element" => "light", "type" => "tank", "leader" => '', "tap" => '', "auto" => '', "slide" => '', "drive" => '', "index" => 1},
    "cleopatra" => {"pic" => "cleopatra0.png", "pic2" => "", "pic3" => "", "tier" => "s", "stars" => "5", "element" => "light", "type" => "attacker", "leader" => '', "tap" => '', "auto" => '', "slide" => '', "drive" => '', "index" => 0}}

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
    { "rack.session" => { username: "mnyiaa", password: "thiccissick" } }
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
    assert_includes last_response.body, 'dana'
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
    assert_includes details, "dana"

    assert_equal details["cleopatra"]["stars"], '5'
    assert_equal details["dana"]["type"], 'tank'

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

  def test_document_editing
    # without signing in -> error
    get "/cleopatra/edit"
    assert_equal 302, last_response.status
    assert_equal "You must be signed in to do that.", session[:message]


    # with signing in -> no error
    get "/cleopatra/edit", {}, admin_session
    assert_equal 200, last_response.status
    assert_includes last_response.body, "<input"
    assert_includes last_response.body, %q(<input name="edited" type="checkbox" required>)
  end

  def test_updating_document
    # post "/new_unit", {@unit_details["cleopatra"]}, admin_session
    #
    # assert_equal 302, last_response.status

    # assert_equal "cleopatra has been updated!", session[:message]

    # get "/changes.txt"
    # assert_equal 200, last_response.status
    # assert_includes last_response.body, "content testing text"
  end
#
#   def test_updating_document_signed_out
#     post "/changes.txt", {content: "new content"}
#
#     assert_equal 302, last_response.status
#     assert_equal "You must be signed in to do that.", session[:message]
#   end
#
#   def test_view_new_document_form
#   get "/new", {}, admin_session
#
#   assert_equal 200, last_response.status
#   assert_includes last_response.body, "<input"
#   assert_includes last_response.body, %q(<button type="submit")
#   end
#
#   def test_view_new_document_form_signed_out
#     get "/new"
#
#     assert_equal 302, last_response.status
#     assert_equal "You must be signed in to do that.", session[:message]
#   end
#
#   def test_create_new_document
#     post "/create", {filename: "test.txt"}, admin_session
#     assert_equal 302, last_response.status
#     assert_equal "test.txt has been created!", session[:message]
#
#     get "/"
#     assert_includes last_response.body, "test.txt"
#   end
#
#   def test_create_new_document_signed_out
#     post "/create", {filename: "test.txt"}
#
#     assert_equal 302, last_response.status
#     assert_equal "You must be signed in to do that.", session[:message]
#   end
#
#   def test_create_new_document_without_filename
#     post "/create", {filename: ""}, admin_session
#     assert_equal 422, last_response.status
#     assert_includes last_response.body, "A valid file-name and type is required!"
#   end
#
#   def test_deleting_document
#     post "/test.txt/delete", {}, admin_session
#
#     assert_equal 302, last_response.status
#     assert_equal "test.txt has been deleted!", session[:message]
#
#     get "/"
#     refute_includes last_response.body, %q(href="/test.txt")
#   end
#
#   def test_deleting_document_signed_out
#     create_document("test.txt")
#
#     post "/test.txt/delete"
#     assert_equal 302, last_response.status
#     assert_equal "You must be signed in to do that.", session[:message]
#   end
#
#   def test_signin_form
#     get "/users/signin"
#
#     assert_equal 200, last_response.status
#     assert_includes last_response.body, "<input"
#     assert_includes last_response.body, %q(<button type="submit")
#   end
#
#   def test_signin
#     post "/users/signin", username: "admin", password: "secret"
#     assert_equal 302, last_response.status
#     assert_equal "Welcome!", session[:message]
#     assert_equal "admin", session[:username]
#
#     get last_response["Location"]
#     assert_includes last_response.body, "Signed in as admin"
#   end
#
#   def test_signin_with_bad_credentials
#     post "/users/signin", username: "guest", password: "shhhh"
#     assert_equal 422, last_response.status
#     assert_nil session[:username]
#     assert_includes last_response.body, "Invalid credentials"
#   end
#
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
#
# # These two tests are doing the same thing, but the 2nd one is more natural.
#   def test_sets_session_value
#     post "/users/signin", username: "admin", password: "secret"
#     get last_response["Location"]
#
#     get "/"
#     assert_equal "admin", session[:username]
#   end
#
#   def test_index_as_signed_in_user
#     get "/", {}, {"rack.session" => { username: "admin"} }
#   end
# # ...end...
#
#   def test_editing_document_signed_out
#     create_document "changes.txt"
#
#     get "/changes.txt/edit"
#
#     assert_equal 302, last_response.status
#     assert_equal "You must be signed in to do that.", session[:message]
#   end

  def teardown
        FileUtils.rm_rf("../test/data")
  end
end
