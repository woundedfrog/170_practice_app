require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'
require 'redcarpet'
require 'yaml'
require 'fileutils'
require 'bcrypt'
require 'pg'
require 'pry'

def reload_db
  @data = PG.connect(dbname: "dcdb")
  #needed for creating new units/cards
  @result = @data.exec("SELECT name, stars, type, element, tier, leader, auto, tap, slide, drive, notes FROM units RIGHT OUTER JOIN mainstats on unit_id = units.id
RIGHT OUTER JOIN substats ON substats.unit_id = units.id;")

end

configure do
  set :erb, escape_html: true
  end

configure do
  enable :sessions
  set :session_secret, 'secret'
end

before do
  @message_note = load_file_data('main')
  @units = load_file_data('unit')
  @soulcards = load_file_data('sc')
  @new_unit = load_file_data('new_unit')['new_unit']
  @new_sc = load_file_data('new_sc')['new_sc']
  reload_db
end

def convert_yml_to_sql
  # return
  # arr = []
  # data = PG.connect(dbname: 'globaldc')  #this is the database it will pour the data into. BE CAREFUL
  # @units.first(50).each_with_index do |unit, idx|
  #
  #   name = unit.first
  #   unit = unit.last
  #
  # done =  data.exec("SELECT * FROM units WHERE name = $$#{name}$$").ntuples > 0
  # next if done

  #     data.exec("INSERT INTO units (name, enabled) VALUES ($$#{name}$$, true)")
  #     data = PG.connect(dbname: 'globaldc')
  #     unit_id = data.exec("SELECT id FROM units WHERE name = $$#{name}$$").first['id']
  #   if unit['element'] == 'grass'
  #     element = 'earth'
  #   else
  #     element = unit['element']
  #   end
  #         data.exec("INSERT INTO mainstats (unit_id, stars, type, element, tier) VALUES (#{unit_id.to_i}, '#{unit['stars']}', '#{unit['type']}', '#{element}', '#{unit['tier']}')")
  #         data.exec("INSERT INTO substats (unit_id, leader, auto, tap, slide, drive, notes) VALUES
  #         (#{unit_id.to_i}, $$#{unit['leader']}$$, $$#{unit['auto']}$$, $$#{unit['tap']}$$, $$#{unit['slide']}$$, $$#{unit['drive']}$$, $$#{unit['notes']}$$)")
  #   data.exec("INSERT INTO profilepics (unit_id, pic1, pic2, pic3, pic4) VALUES (#{unit_id.to_i}, '#{unit['pic']}', '#{unit['pic2']}', '#{unit['pic3']}', 'emptyunit0.png')")
  #
  #
  # end
  #
  # data.close
#  SPLITS THE LOAD. Hide the part below, then unhide it and hide top part then refresh the page ELSE connects are too many.

  # data = PG.connect(dbname: 'globaldc')
  # @units.drop(50).each_with_index do |unit, idx|
  #
  #   name = unit.first
  #   unit = unit.last
  #
  #   # arr << unit['stars']
  #   # arr << unit['tier']
  #   # arr << unit['element']
  #   # arr << unit['type']
  #
  # done =  data.exec("SELECT * FROM units WHERE name = $$#{name}$$").ntuples > 0
  # next if done
  #     data.exec("INSERT INTO units (name, enabled) VALUES ($$#{name}$$, true)")
  #     data = PG.connect(dbname: 'globaldc')
  #     unit_id = data.exec("SELECT id FROM units WHERE name = $$#{name}$$").first['id']
  #   if unit['element'] == 'grass'
  #     element = 'earth'
  #   else
  #     element = unit['element']
  #   end
  #         data.exec("INSERT INTO mainstats (unit_id, stars, type, element, tier) VALUES (#{unit_id.to_i}, '#{unit['stars']}', '#{unit['type']}', '#{element}', '#{unit['tier']}')")
  #         data.exec("INSERT INTO substats (unit_id, leader, auto, tap, slide, drive, notes) VALUES
  #         (#{unit_id.to_i}, $$#{unit['leader']}$$, $$#{unit['auto']}$$, $$#{unit['tap']}$$, $$#{unit['slide']}$$, $$#{unit['drive']}$$, $$#{unit['notes']}$$)")
  #   data.exec("INSERT INTO profilepics (unit_id, pic1, pic2, pic3, pic4) VALUES (#{unit_id.to_i}, '#{unit['pic']}', '#{unit['pic2']}', '#{unit['pic3']}', 'emptyunit0.png')")
  #
  #
  # end
end

helpers do
  def long_stat_key?(key)
    %w[leader auto tap slide drive notes date].include?(key.to_s)
  end

  def short_stat_key?(key)
    %w[tier stars type element].include?(key.to_s)
  end

  def special_key?(key)
    %w[pic pic1 pic2 pic3 pic4].include?(key.to_s)
  end

  def format_image_from_tier(ratings)
    formated_images = []
    ratings.split(' ').each do |tier|
      formated_images << "<img class=\'short-stat-content tier_rating\' src='/images/class#{tier.downcase}.png'/>"
    end
    formated_images
  end

  def format_stat(stat_key, info_val)
    if %w[water fire grass light dark].include?(info_val)
      "<img class=\'short-stat-content element-type-pic\' src='/images/#{info_val}.png'/>"
    elsif %w[tank attacker buffer healer debuffer].include?(info_val)
      "<img class=\'short-stat-content element-type-pic\' src='/images/#{info_val}.png'/>"
    elsif stat_key == 'stars'
      "<img class=\'short-stat-content star_rating\' src='/images/star#{info_val}.png'/>"
    else
      info_val
    end
  end

  def sort_by_and_select_type(unit_info, catagory_type)
    keys = []
    unit_info.each do |_unit_name|
      if catagory_type == 'tier'
        _unit_name.each do |stat, value|
          next if stat != catagory_type

          keys << value.split(' ').map(&:to_i)
        end
        keys.flatten!
      else
        _unit_name.each { |stat, value| keys << value if stat == catagory_type }
      end
  end

    if "date" == catagory_type
      return keys.uniq.map!(&:to_s).sort! { |a,b| DateTime.parse(a) <=> DateTime.parse(b) }.reverse
    end

    if "tier" == catagory_type
      return keys.uniq.sort.map!(&:to_s).reverse
    end

    keys.uniq.sort.map!(&:to_s)
  end

  def upcase_name(name)
    name.split(' ').map(&:capitalize).join(' ')
  end

  def catagory(idx)
    case idx
    when 0
      'PVE'
    when 1
      'PVP'
    when 2
      'RAID'
    when 3
      'WORLD BOSS'
    end
  end
end

def delete_selected_file(name)
  if !name.include?('.jpg')
    Dir.glob('./public/images/').each do |f|
      FileUtils.rm(f + name)
    end
  else
    Dir.glob('public/images/sc/').each do |f|
      FileUtils.rm(f + name)
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
  credentials_path = if ENV['RACK_ENV'] == 'test'
                       File.expand_path('test/users.yml', __dir__)
                     else
                       File.expand_path('users.yml', __dir__)
                     end
  YAML.load_file(credentials_path)
end

def user_signed_in?
  session.key?(:username)
end

def require_user_signin
  return unless user_signed_in? == false

  session[:message] = 'You must be signed in to do that.'
  redirect '/'
end

def file_path
  cards = ''
  units = ''
  if ENV['RACK_ENV'] == 'test'
    cards = File.expand_path('test/public/images/sc/', __dir__)
    units = File.expand_path('test/public/images/', __dir__)
  else
    cards = File.expand_path('public/images/sc/', __dir__)
    units = File.expand_path('public/images/', __dir__)
  end
  [units, cards]
end

def load_file_data(name)
  case name
  when 'unit'
    load_unit_details
  when 'sc'
    load_soulcards_details
  when 'main'
    note = File.expand_path('data/maininfo.yml', __dir__)
    YAML.load_file(note)
  when 'new_sc'
    load_new_soulcard
  when 'new_unit'
    load_new_unit
  end
end

def load_soulcards_details
  unit_list = if ENV['RACK_ENV'] == 'test'
                File.expand_path('test/data/sc/soul_cards.yml', __dir__)
              else
                File.expand_path('data/sc/soul_cards.yml', __dir__)
              end
  YAML.load_file(unit_list)
end

def load_new_soulcard
  unit_list = if ENV['RACK_ENV'] == 'test'
                File.expand_path('test/data/sc/new_soul_card.yml', __dir__)
              else
                File.expand_path('data/sc/new_soul_card.yml', __dir__)
              end
  YAML.load_file(unit_list)
end

def load_new_unit
  unit_list = if ENV['RACK_ENV'] == 'test'
                File.expand_path('test/data/new_unit.yml', __dir__)
              else
                File.expand_path('data/new_unit.yml', __dir__)
              end
  YAML.load_file(unit_list)
end

def load_unit_details
  unit_list = if ENV['RACK_ENV'] == 'test'
                File.expand_path('test/data/unit_details.yml', __dir__)
              else
                File.expand_path('data/unit_details.yml', __dir__)
              end
  YAML.load_file(unit_list)
end

def get_unit_name(data_path, index)
  unit_name = ''
  data_path.each do |name, info|
    unit_name = name if info['index'] == index
  end
  unit_name
end

def get_max_index_number(list)
  indexes = []
  list.each do |unit, stats|
    indexes << stats['index']
  end
  indexes.sort!

  max = indexes.max + 1
  available_indexes = (1..max).to_a - indexes
  available_indexes.min
end

def group_by_catagory_tier(details, catagory_vals)
  groups = [{}, {}, {}, {}]
  groups.size.times do |idx|
    catagory_vals.each do |num|
      details.each do |unit|
        tiers = unit['tier'].split(' ').map(&:to_i)
        groups[idx][num.to_s] = {} if groups[idx][num].nil?
        groups[idx][num][unit['name']] = unit if tiers[idx] == num.to_s.to_i
      end
    end
  end
  groups
end

def sort_by_given_info(unit_info, stars, catagory_vals = nil, type = nil)
  star_rating = stars[0]
  # units_by_stars = nil

  if catagory_vals == 'equips'
    unit_info = unit_info.select { |_name, stat| stat['stars'] == star_rating }.to_h
  end
  return group_by_catagory_tier(unit_info, catagory_vals) if type == 'tier'
  unit_info
end

def get_unit_or_sc_from_keys(keys)
  cards = @soulcards
  units = @units
  return [nil, nil] if keys.empty?

  unit_results = search_stats_for_key(units, keys)
  card_results = search_stats_for_key(cards, keys)

  [unit_results.to_h, card_results.to_h]
end

def search_stats_for_key(stats, words)
  results = []

  stats.each do |name, info_hash|
    if name.to_s.downcase.include?(words.downcase)
      results << [name, info_hash]
    else
      info_hash.each do |key, val|
        val = val.to_s.downcase
        if val.include?(words) || key.include?(words)
          results << [name, info_hash]
        end
      end
    end
  end
  results
end

def create_file_from_upload(uploaded_file, pic_param, directory)
  if !uploaded_file.nil?
    (tmpfile = uploaded_file[:tempfile]) && (pname = uploaded_file[:filename])
    path = File.join(directory, pname)
    File.open(path, 'wb') { |f| f.write(tmpfile.read) }
  elsif pic_param.empty?
    pname = 'emptyunit0.png'
  else
    pname = pic_param
  end

  directory.gsub!('public', '')
  pname.include?(directory) ? pname : "#{directory}/" + pname
end

def unit_or_sc_exist?(type, name)
  data = if type == 'unit'
           @units
         else
           @soulcards
           data = PG.connect(dbname: 'dcdb')
           data.exec("SELECT * FROM soulcards
           RIGHT OUTER JOIN scstats ON sc_id = soulcards.id WHERE name = '#{name}'")
         end
  if data.first['name'].include?(name) == false
    session[:message] = "#{name} doesn't exist."
    redirect '/'
  end
end

# ##################

def render_markdown(file)
  markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  markdown.render(file)
end

def load_file_content(filename)
  content = File.read(filename)
  render_markdown(content)
end

def check_and_fetch_date(data, name)
  if data.key?(name)
    return data[name]['date'] if data[name].key?('date')
  end
  ''
end

# ##################

not_found do
  redirect '/'
end

get '/users/signin' do
  erb :signin
end

post '/users/signin' do
  username = params[:username]
  password = params[:password]

  if valid_credentials?(username, password)
    session[:username] = username
    session[:message] = 'Welcome!'
    redirect '/'
  else
    session[:message] = 'Invalid credentials!'
    status 422
    erb :signin
  end
end

get '/search/' do
  keys = params[:search_query].downcase

  database = PG.connect(dbname: 'dcdb')

  @units1 =
  database.exec("SELECT name, pic1, stars, type, element, leader, auto, tap, slide, drive, notes
  FROM units
  RIGHT OUTER JOIN mainstats on mainstats.unit_id = units.id
  RIGHT OUTER JOIN substats ON substats.unit_id = units.id
  RIGHT OUTER JOIN profilepics ON profilepics.unit_id = units.id
  WHERE name LIKE $$%#{keys}%$$ ORDER BY name")

  @exclude_list = @units1.map {|row| row['name']}
  @units2 =
  database.exec("SELECT name, pic1, stars, type, element, leader, auto, tap, slide, drive, notes
  FROM units
  RIGHT OUTER JOIN mainstats on mainstats.unit_id = units.id
  RIGHT OUTER JOIN substats ON substats.unit_id = units.id
  RIGHT OUTER JOIN profilepics ON profilepics.unit_id = units.id
  WHERE leader LIKE $$%#{keys}%$$ OR auto LIKE $$%#{keys}%$$ OR tap LIKE $$%#{keys}%$$ OR slide LIKE $$%#{keys}%$$ OR drive LIKE $$%#{keys}%$$ OR notes LIKE $$%#{keys}%$$ ORDER BY name")

  @soulcards = database.exec("SELECT name, stars, pic1 FROM soulcards
  RIGHT OUTER JOIN scstats ON sc_id = soulcards.id WHERE name LIKE $$%#{keys}%$$")

  @soulcards2 = database.exec("SELECT name, stars, pic1 FROM soulcards RIGHT OUTER JOIN scstats ON sc_id = soulcards.id WHERE LOWER(passive) LIKE $$%#{keys}%$$")

  erb :search
end

get '/' do
  convert_yml_to_sql  #don't need to run this unless you want to convert the databases.

  # data = PG.connect(dbname: 'dcdb')
  # @units = data.exec("SELECT name, stars, pic1, created_on FROM units
  #  RIGHT OUTER JOIN mainstats ON mainstats.unit_id = units.id
  #  RIGHT OUTER JOIN profilepics ON profilepics.unit_id = units.id ORDER BY created_on DESC, id DESC LIMIT 4")

  data = PG.connect(dbname: 'dcdb')

  @new_units = data.exec("SELECT name, stars, pic1, created_on FROM units
   RIGHT OUTER JOIN mainstats ON mainstats.unit_id = units.id
   RIGHT OUTER JOIN profilepics ON profilepics.unit_id = units.id ORDER BY created_on DESC, id DESC LIMIT 4")

  @new_soulcards = data.exec("SELECT name, stars, pic1 FROM soulcards
   RIGHT OUTER JOIN scstats ON sc_id = soulcards.id ORDER BY created_on DESC LIMIT 4")


  erb :home
end

get '/basics' do
  path = File.expand_path('data/basics.md', __dir__)
  @markdown = load_file_content(path)
  erb :starterguide
end

get '/:filename/edit' do
  file = File.expand_path("data/#{params[:filename]}.yml", __dir__)
  @name = params[:filename]
  @content = YAML.dump(YAML.load_file(file))

  erb :edit_notice
end

get '/download/:filename' do |filename|
  fname = filename
  ftype = 'Application/octet-stream'

  if filename.include?('soul')
    send_file "./data/sc/#{filename}", filename: fname, type: ftype
  elsif filename.include?('unit') ||
        filename.include?('maininfo') ||
        filename.include?('basics.md')
    send_file "./data/#{filename}", filename: fname, type: ftype
  elsif filename.include?('.jpg')
    send_file "./public/images/sc/#{filename}", filename: fname, type: ftype
  else
    send_file "./public/images/#{filename}", filename: fname, type: ftype
  end
  redirect '/'
end

get '/show_files/:file_name/remove' do
  delete_selected_file(params[:file_name])
  redirect '/show_files'
end

get '/equips/new_sc' do
  @card = @new_sc
  @data = PG.connect(dbname: "dcdb")
  result = @data.exec("SELECT pic1, stars, stats, passive FROM soulcards RIGHT OUTER JOIN scstats on sc_id = soulcards.id")
  @new_profile = result

  erb :new_sc
end

get '/new_unit' do
  @new_profile = reload_db.fields
  data = PG.connect(dbname: "dcdb")
  @profile_pic_table = data.exec("SELECT * FROM profilepics")
  erb :new_unit
end

get '/:catagory/:star_rating' do
  star_rating = params[:star_rating][0]

  if ![5, 4, 3].include?(star_rating.to_i)
    session[:message] = 'There are no units or soulcards by that tier!'
    redirect '/'
  end

  if params[:catagory] == 'equips'
    data = PG.connect(dbname: "dcdb")

    @cards = data.exec("SELECT name, pic1, stars FROM soulcards
     RIGHT OUTER JOIN scstats ON sc_id = soulcards.id WHERE stars = '#{star_rating}' AND enabled = 't'")
    erb :index_sc
  else
    redirect '/'
  end
end

get '/childs/:star_rating/:unit_name/edit' do
  name = params[:unit_name]
  @unit_name = name

  data = PG.connect(dbname: "dcdb")
  current_id = data.exec("SELECT * FROM units WHERE name = '#{name}';")
  @new_id = current_id.first['id'].to_i

  @current_unit = data.exec("SELECT enabled, id, name,  pic1, pic2, pic3, pic4, stars, type, element, tier, leader, auto, tap, slide, drive, notes, created_on
  FROM units
  RIGHT OUTER JOIN mainstats on mainstats.unit_id = units.id
  RIGHT OUTER JOIN substats ON substats.unit_id = units.id
  RIGHT OUTER JOIN profilepics ON profilepics.unit_id = units.id
  WHERE name = '#{name}'").first

  erb :edit_unit
end

get '/childs/:star_rating/:unit_name' do
  name = params[:unit_name]
  db = PG.connect(dbname: 'dcdb')

  @unit_data = db.exec("SELECT units.id, name, stars, type, element, tier, leader, auto, tap, slide, drive, notes FROM units
  RIGHT OUTER JOIN mainstats on unit_id = units.id
  RIGHT OUTER JOIN substats ON substats.unit_id = units.id;")

  @unit = db.exec("SELECT name, created_on AS date FROM units WHERE name = '#{name}';")

  redirect '/' if @unit.ntuples == 0

  id = db.exec("SELECT id FROM units WHERE name = '#{name}';")[0]['id']


  @mainstats = db.exec("SELECT stars, type, element, tier FROM mainstats WHERE unit_id = #{id};")[0]

  @substats = db.exec("SELECT leader, auto, tap, slide, drive, notes FROM substats WHERE unit_id = #{id};")[0]
  @pics = db.exec("SELECT * FROM profilepics WHERE unit_id = #{id};")[0]

  erb :view_unit
end

#shows a list of all units in the database.
get '/db_index' do
  database = PG.connect(dbname: 'dcdb')
  @enabled_index = database.exec("SELECT id, name, stars, enabled, created_on FROM units RIGHT OUTER JOIN mainstats ON mainstats.unit_id = units.id
  WHERE enabled = 't' ORDER BY id ASC, name DESC")

  @disabled_sc = database.exec("SELECT id, name, stars, enabled, created_on FROM soulcards RIGHT OUTER JOIN scstats ON scstats.sc_id = soulcards.id
  WHERE enabled = 'f' ORDER BY id ASC, name DESC")

  @disabled_index = database.exec("SELECT id, name, stars, enabled, created_on FROM units RIGHT OUTER JOIN mainstats ON mainstats.unit_id = units.id
  WHERE enabled = 'f' ORDER BY id ASC, name DESC")

  erb :unit_index
end

get '/equips/:star_rating/:sc_name' do
  name = params[:sc_name]

  data = PG.connect(dbname: 'dcdb')
  @current_card = data.exec("SELECT name, pic1, stars, stats, passive FROM soulcards RIGHT OUTER JOIN scstats ON sc_id = soulcards.id WHERE name = '#{name}'")

  redirect '/' if @current_card.ntuples == 0

  @sc_name = @current_card[0]["name"]
  erb :view_sc
end

get '/equips/:star_rating/:sc_name/edit' do
  require_user_signin
  name = params[:sc_name]
  @card_name = name

  data = PG.connect(dbname: "dcdb")
  @current_card = data.exec("SELECT id, enabled, pic1, stars, stats, passive FROM soulcards
   RIGHT OUTER JOIN scstats ON sc_id = soulcards.id
   WHERE name = '#{name}'").first
   @new_id = @current_card['id']

  erb :edit_sc
end

get '/childs/:star_rating/sort_by/:type' do
  @star_rating = params[:star_rating]
  @catagory_type = params[:type]
  unit_info = @units

  db = PG.connect(dbname: 'dcdb')
  @unit_data = db.exec("SELECT name, created_on AS date, stars, type, element, tier, pic1 FROM units
  RIGHT OUTER JOIN mainstats on unit_id = units.id
  RIGHT OUTER JOIN profilepics ON profilepics.unit_id = units.id
  WHERE stars = '#{@star_rating[0]}' AND enabled = 't'")


  if %w[3 4 5].any? { |star| star == @star_rating[0] }
    @catagories = sort_by_and_select_type(@unit_data, @catagory_type)
    @units =
      sort_by_given_info(@unit_data, @star_rating, @catagories, @catagory_type)

    return erb :sort_by_tier if @catagory_type == 'tier'
  else
    session[:message] = 'There are no units by that tier!'
    redirect '/'
  end
  @units = db.exec("SELECT name, created_on AS date, stars, type, element, tier, pic1 FROM units
  RIGHT OUTER JOIN mainstats on unit_id = units.id
  RIGHT OUTER JOIN profilepics ON profilepics.unit_id = units.id
  WHERE stars = '#{@star_rating[0]}' AND enabled = 't' ORDER BY element ASC, name ASC")

  erb :sort_by_type
end

get '/show_unit_details' do
  @unit_details = @units
  @sc_details = @soulcards

  db = PG.connect(dbname: 'dcdb')
  @unit_details = db.exec("SELECT name AS total FROM units ORDER BY name")
  @sc_details = db.exec("SELECT name AS total FROM soulcards ORDER BY name")
  erb :show_unit_details
end

get '/show_files' do
  units = File.join(file_path[0], '*')
  cards = File.join(file_path[1], '*')
  @units = Dir.glob(units).map do |path|
    next if File.directory?(path)

    File.basename(path)
  end
  @soulcards = Dir.glob(cards).map do |path|
    next if File.directory?(path)

    File.basename(path)
  end
  erb :file_list
end

get '/upload' do
  erb :upload
end

post '/equips/new_sc' do
  require_user_signin

  original_name = params[:original_unit_name]
  unit_id = params['id'].to_i
  name = params[:sc_name].downcase

#change this params[:pic] to params[:pic1] after old data had migrated
  pname = create_file_from_upload(params[:filepic1], params[:pic1], 'public/images/sc')

  data = PG.connect(dbname: "dcdb")
  unit_found = data.exec("SELECT * FROM soulcards WHERE name = '#{name}'").first

if data.exec("SELECT * FROM soulcards WHERE id = '#{unit_id}'").first.nil? == true

    check_enabled = (params[:enabled] == '1') ? 't' : 'f'

    data.exec("INSERT INTO soulcards (name, enabled) VALUES ('#{name}', '#{check_enabled}')")
    reload_db

    current_max_id = data.exec("SELECT * FROM soulcards WHERE name = '#{name}' ORDER BY id DESC LIMIT 1")
    new_id = current_max_id.first['id'].to_i


    data.exec("INSERT INTO scstats (sc_id, pic1, stars, stats, passive) VALUES
    ('#{new_id}', '#{pname}', '#{params[:stars]}', '#{params[:stats]}', '#{params[:passive]}')")


  else

    check_enabled = (params[:enabled].to_i == 1) ? 't' : 'f'

    data.exec("UPDATE soulcards SET name = '#{name}', enabled = '#{check_enabled}' WHERE name = '#{original_name}' AND id = '#{unit_id}'")
    reload_db

    data.exec("UPDATE scstats SET pic1 = '#{pname}', stars = '#{params[:stars]}', stats = '#{params[:stats]}', passive = '#{check_enabled}' WHERE sc_id = '#{unit_id}'")
    # reload_db
  end
    reload_db


  session[:message] = "New Soulcard called #{name.upcase} has been created."
  redirect "/equips/#{params[:stars]}stars/#{name.gsub(' ', '%20')}"
end

# post '/equips/new_sc' do
#   require_user_signin
#   card_data = @soulcards
#
#   @current_unit = card_data[params[:sc_name]]
#   @max_index_val = get_max_index_number(card_data)
#
#   data = card_data
#   name = params[:sc_name].downcase
#   index = params[:index].to_i
#
#   original_card = card_data.select do |unit, info|
#     unit if index == info['index'].to_i
#   end
#
#   pname = create_file_from_upload(params[:file], params[:pic], 'public/images/sc')
#
#   if card_data.include?(name) && index != card_data[name]['index']
#     session[:message] =
#       'A card by that name already exists. Please create a different card.'
#     status 422
#
#     if params['edited']
#       temp_name = get_unit_name(card_data, index)
#       redirect "/equips/#{params[:stars]}stars/#{temp_name}/edit"
#     else
#       redirect '/equips/new_sc'
#     end
#
#   else
#     data.delete(original_card.keys.first)
#     data[name] = {}
#   end
#
#   data[name]['pic'] = pname.include?('.') ? pname : (pname + '.jpg')
#   data[name]['stars'] = params[:stars]
#   data[name]['stats'] = params[:stats]
#   data[name]['passive'] = params[:passive]
#   data[name]['index'] = index
#
#   File.write('data/sc/soul_cards.yml', YAML.dump(data))
#   session[:message] = "New Soulcard called #{name.upcase} has been created."
#   redirect "/equips/#{params[:stars]}stars/#{name.gsub(' ', '%20')}"
# end

get '/childs/:star_rating/:unit_name/remove' do
  require_user_signin
  unit = params[:unit_name]
  units_info = @units

  data = PG.connect(dbname: "dcdb")
  unit_found = data.exec("SELECT * FROM units WHERE name = '#{unit}'").first
  if unit_found.nil?
    status 422
    session[:message] = "That unit doesn't exist."
  else

    data.exec("DELETE FROM units WHERE name = '#{unit}'")
    # units_info.delete(unit)
    # File.write('data/unit_details.yml', YAML.dump(units_info))
    session[:message] = "#{unit.upcase} unit was successfully deleted."
  end
  redirect '/'
end

post '/new_unit' do
  unit_data = @units

  # @current_unit = unit_data[params[:unit_name]]
  # @max_index_val = get_max_index_number(unit_data)

  # data = unit_data
  original_name = params[:original_unit_name]
  name = params[:unit_name].downcase
  unit_id = params['id'].to_i
  data = PG.connect(dbname: "dcdb")

  pname1 = create_file_from_upload(params[:filepic1], params[:pic1], 'public/images')
  pname2 = create_file_from_upload(params[:filepic2], params[:pic2], 'public/images')
  pname3 = create_file_from_upload(params[:filepic3], params[:pic3], 'public/images')
  pname4 = create_file_from_upload(params[:filepic4], params[:pic4], 'public/images')

  check_enabled = (params[:enabled].to_i == 1) ? 't' : 'f'

# this checks if there is a existing unit @ the specific ID
  if data.exec("SELECT * FROM units WHERE id = '#{unit_id}'").first.nil? == true

    data.exec("INSERT INTO units (name, enabled) VALUES ('#{name}', '#{check_enabled}')")
    reload_db

    current_max_id = data.exec("SELECT id FROM units where name = '#{name}' ORDER BY id DESC LIMIT 1")
    new_id = current_max_id.first['id'].to_i

    if params[:element] == 'grass'
      element = 'earth'
    else
      element = params[:element]
    end
    data.exec("INSERT INTO mainstats (unit_id, stars, type, element, tier) VALUES
    ('#{new_id}', '#{params[:stars]}', '#{params[:type]}', '#{element}', '#{params[:tier]}')")

    data.exec("INSERT INTO substats (unit_id, leader, auto, tap, slide, drive, notes) VALUES
    ('#{new_id}', $$#{params[:leader]}$$, $$#{params[:auto]}$$, $$#{params[:tap]}$$, $$#{params[:slide]}$$, $$#{params[:drive]}$$, $$#{params[:notes]}$$)")

    data.exec("INSERT INTO profilepics (unit_id, pic1, pic2, pic3, pic4) VALUES
    ('#{new_id}', '#{pname1}', '#{pname2}', '#{pname3}', '#{pname4}')")
    reload_db

else
# IF there is a unit then it is updated by using the original name and it's ID
    data.exec("UPDATE units SET name = '#{name}', enabled = '#{check_enabled}' WHERE name = '#{original_name}' AND id = '#{unit_id}'")
    reload_db

    if params[:element] == 'grass'
      element = 'earth'
    else
      element = params[:element]
    end
    data.exec("UPDATE mainstats SET stars = '#{params[:stars]}', type = '#{params[:type]}', element = '#{element}', tier = '#{params[:tier]}' WHERE unit_id = #{unit_id}")
    # reload_db

    data.exec("UPDATE substats SET leader = $$#{params[:leader]}$$, auto = $$#{params[:auto]}$$, tap = $$#{params[:tap]}$$, slide = $$#{params[:slide]}$$, drive = $$#{params[:drive]}$$, notes = $$#{params[:notes]}$$ WHERE unit_id = #{unit_id}")

    data.exec("UPDATE profilepics SET pic1 = '#{pname1}', pic2 = '#{pname2}', pic3 = '#{pname3}', pic4 = '#{pname4}' WHERE unit_id = #{unit_id}")
    reload_db
  end

  session[:message] = "New unit called #{name.upcase} has been created."
  redirect "/"
end

###### this is used to save and import from YML to sql
# post '/new_unit2' do
#   unit_data = @units
#
#   @current_unit = unit_data[params[:unit_name]]
#   @max_index_val = get_max_index_number(unit_data)
#
#   data = unit_data
#   name = params[:unit_name].downcase
#
#
#   # pname1 = params[:pic1]
#   #
#   # if params[:pic2] == '' || params[:pic2].nil?
#   #   pname2 = 'emptyunit0.png'
#   # else
#   #   pname2 = params[:pic2]
#   # end
#   # if params[:pic3] == '' || params[:pic3].nil?
#   #   pname3 = 'emptyunit0.png'
#   # else
#   #   pname3 = params[:pic3]
#   # end
#   # if params[:pic4] == '' || params[:pic4].nil?
#   #   pname4 = 'emptyunit0.png'
#   # else
#   #   pname4 = params[:pic4]
#   # end
#
#     pname1 = create_file_from_upload(params[:filepic], params[:pic], 'public/images')
#     pname2 = create_file_from_upload(params[:filepic2], params[:pic2], 'public/images')
#     pname3 = create_file_from_upload(params[:filepic3], params[:pic3], 'public/images')
#     pname4 = create_file_from_upload(params[:filepic4], params[:pic4], 'public/images')
#   #
#   # piname1 = pname1.include?('.') ? pname1 : (pname1 + '.png')
#   # piname2 = pname2.include?('.') ? pname2 : (pname2 + '.png')
#   # piname3 = pname3.include?('.') ? pname3 : (pname3 + '.png')
#   # piname4 = pname4.include?('.') ? pname4 : (pname4 + '.png')
#
#   data = PG.connect(dbname: "dcdb")
#
#   data.exec("INSERT INTO units (name, created_on) VALUES ('#{name}', '#{params[:date]}')")
#   reload_db
#
#   current_max_id = data.exec("SELECT * FROM units ORDER BY id DESC LIMIT 1")
#   new_id = current_max_id.first['id'].to_i
#
#   if params[:element] == 'grass'
#     element = 'earth'
#   else
#     element = params[:element]
#   end
#   data.exec("INSERT INTO mainstats (unit_id, stars, type, element, tier) VALUES
#   ('#{new_id}', '#{params[:stars]}', '#{params[:type]}', '#{element}', '#{params[:tier]}')")
#   # reload_db
#
#   data.exec("INSERT INTO substats (unit_id, leader, auto, tap, slide, drive, notes) VALUES
#   ('#{new_id}', '#{params[:leader]}', '#{params[:auto]}', '#{params[:tap]}', '#{params[:slide]}', '#{params[:drive]}', '#{params[:notes]}')")
#
#   data.exec("INSERT INTO profilepics (unit_id, pic1, pic2, pic3, pic4) VALUES
#   ('#{new_id}', '#{pname1}', '#{pname2}', '#{pname3}', '#{pname4}')")
#   reload_db
#
#   session[:message] = "New unit called #{name.upcase} has been created."
#   redirect "/test"
# end
########

get '/equips/:star_rating/:sc_name/remove' do
  require_user_signin
  card = params[:sc_name]
  cards_info = @soulcards

  data = PG.connect(dbname: "dcdb")
  card_found = data.exec("SELECT * FROM soulcards WHERE name = '#{card}'").first
  if card_found.nil?
    status 422
    session[:message] = "That soulcard doesn't exist."
  else

    data.exec("DELETE FROM soulcards WHERE name = '#{card}'")
    session[:message] = "#{card.upcase} unit was successfully deleted."
  end

  redirect '/'
end

# used to upload a file without creating a new unit
post '/upload' do
  require_user_signin
  unless params[:file] &&
         (tmpfile = params[:file][:tempfile]) &&
         (name = params[:file][:filename])
    session[:message] = 'No file selected'
    redirect '/upload'
  end

  directory =
    if name.include?('png')
      file_path[0]
    elsif name.include?('jpg')
      file_path[1]
    elsif ['unit_details.yml', 'maininfo.yml', 'basics.md'].include?(name)
      'data/'
    elsif name == 'soul_cards.yml'
      'data/sc/'
    else
      session[:message] = 'Filename must match original filename'
      redirect '/upload'
    end

  path = File.join(directory, name)
  File.open(path, 'wb') { |f| f.write(tmpfile.read) }
  session[:message] = 'file uploaded!'
  erb :upload
end

post '/update/:filename' do
  name = params[:filename] + '.yml'
  content = params[:content]
  directory =
    if ['unit_details.yml', 'maininfo.yml', 'basics.md'].include?(name)
      session[:message] = "#{name} was updated"
      'data/'
    else
      session[:message] = 'Filename must match original filename'
      redirect '/upload'
    end

  path = File.join(directory, name)
  File.open(path, 'wb') { |f| f.write(content) }
  session[:message] = 'file uploaded!'
  redirect '/'
end
