require File.expand_path('../ricemine.rb', __FILE__)
use Rack::ShowExceptions
run Sinatra::Application
