get '/test' do
  note = File.expand_path('data/ragna/ragna01.yml', __dir__)
  @file = YAML.load_file(note)
  # binding.pry
  @title = "This is a testview!"
  erb :test
end
