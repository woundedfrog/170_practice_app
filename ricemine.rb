require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'
require 'redcarpet'
require 'yaml'
require 'fileutils'
require 'bcrypt'
require 'pry'
require 'zip' # allows for zipping files

configure do
  set :erb, escape_html: true
end

configure do
  enable :sessions
  set :session_secret, 'secret'
end

before do

  begin
    @message_note = load_file_data('main')
  rescue Psych::SyntaxError => ex
    p ex.file
    p ex.message
  end
  @units = load_file_data('unit')
  @soulcards = load_file_data('sc')
  @new_unit = load_file_data('new_unit')['new_unit']
  @new_sc = load_file_data('new_sc')['new_sc']
end

helpers do
  def long_stat_key?(key)
    %w[leader auto tap slide drive notes date].include?(key.to_s)
  end

  def short_stat_key?(key)
    %w[tier stars type element].include?(key.to_s)
  end

  def special_key?(key)
    %w[pic pic1 pic2 pic3 index].include?(key.to_s)
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
    unit_info.each do |_unit_name, unit_details|
      if catagory_type == 'tier'
        unit_details.each do |stat, value|
          next if stat != catagory_type

          keys << value.split(' ').map(&:to_i)
        end
        keys.flatten!
      else
        unit_details.each { |stat, value| keys << value if stat == catagory_type }
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

  def flatten_if_possible(value)
    if value.class == Array
      value.flatten.join(' ')
    else
      value
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
  history_update("deleted file: #{name}")
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
      details.each do |name, info|
        tiers = info['tier'].split(' ').map(&:to_i)
        groups[idx][num.to_s] = {} if groups[idx][num].nil?
        groups[idx][num][name] = info if tiers[idx] == num.to_s.to_i
      end
    end
  end
  groups
end

def sort_by_given_info(unit_info, stars, catagory_vals = nil, type = nil)
  star_rating = stars[0]
  units_by_stars =
   unit_info.select { |_name, stat| stat['stars'] == star_rating }.to_h

if stars == 'all'
  return group_by_catagory_tier(unit_info, catagory_vals) if type == 'tier'
else
  return group_by_catagory_tier(units_by_stars, catagory_vals) if type == 'tier'
end
  units_by_stars.sort_by { |name, __stats| name }.to_h
end

def get_unit_or_sc_from_keys(keys)
  return [nil, nil] if keys.empty?

  unit_results = search_stats_for_key(@units, keys)
  card_results = search_stats_for_key(@soulcards, keys)

  [unit_results.to_h, card_results.to_h]
end

def search_stats_for_key(stats, words, name_or_all = 'all')
  results = []

  stats.each do |name, info_hash|
    if name.to_s.downcase.include?(words.downcase)
      results << [name, info_hash]
    else
      next unless name_or_all == 'all'
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
  elsif params[:pic].empty?
    pname = 'emptyunit0.png'
  else
    pname = pic_param
  end

  directory.gsub!('public', '')
  pname.include?(directory) ? pname : "#{directory}/" + pname
end

# def sort_tier_catagory(tiers_arr, units, index)
#   units.sort_by {|k,v| v['tier'].split(' ')[index]}
# end

def unit_or_sc_exist?(type, name)
  data = if type == 'unit'
           load_unit_details
         else
           load_soulcards_details
         end
  if data.include?(name) == false
    session[:message] = "#{name} doesn't exist."
    redirect '/'
  end
end

def select_disabled_profiles(details)
  details.select {|k, v| v['enabled'] == 'false'}
end

def select_enabled_profiles(details)
  details.select {|k, v| v['enabled'] == 'true'}
end

def exclude_specific_profiles_from_list(data, keys)
  data.select { |k,v| [k,v] unless k == keys || k.include?(keys) }
end

def skills_splitter(skills)
  leader, auto, tap, slide, drive = [], [] , [], [], []
  key = ''

  skills.split.each_with_index do |word, idx|
    if %w(leader lead slide tap drive auto).include?(word.downcase)
      key = word.downcase
      next
    end

   case key#%w(leader slide tap drive).include?(word)
   when 'lead'
     leader << word
   when 'leader'
     leader << word
   when 'slide'
     slide << word
   when 'tap'
     tap << word
   when 'auto'
     auto << word
   else
     drive << word
   end
  end
  [leader, auto, tap, slide, drive].map{ |x| x.join(" ")}
end

def sc_formatter(stats)
  # if stats[-1] == '.'
  #   return stats
  # else
  #   return stats + '.'
  # end
  stats
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

#zipping IMAGE files
def zip_it(path)
  if path.include?('unit')
    zip_name = path
    Zip::File.open(zip_name, Zip::File::CREATE) do |zipfile|
      # Find all .csv files in the exports directory
      Dir.glob("./public/images/*") do |filepath|
        filename = filepath.split("/").pop
        zipfile.add(filename, filepath)
      end
    end
  else
    zip_name = path
    Zip::File.open(zip_name, Zip::File::CREATE) do |zipfile|
      # Find all .csv files in the exports directory
      Dir.glob("./public/images/sc/*") do |filepath|
        filename = filepath.split("/").pop
        zipfile.add(filename, filepath)
      end
    end
  end
end
#zipping IMAGE files END
## format stats from Create new SC
def format_input_stats(stats, passive_skill = false)
  arr = [[],[]]
  if !passive_skill
    stats.split(' ').each_with_index do |part, idx|
      if idx < 4
        arr[0] << part
      else
        arr[1] << part
      end
    end
  else
    key = ''
    stats.split(' ').each_with_index do |word, idx|

      key = word if ['restriction', 'restrictions'].include?(word.downcase) || ['ability', 'abilities'].include?(word.downcase)
      if key.downcase.include?('restrict')
        arr[0] << word
      else
        arr[1] << word
      end
    end
    arr[0] = [arr[0][0], arr[0][1..-1].join(' ')]
    arr[1] = [arr[1][0], arr[1][1..-1].join(' ')]
    arr
  end
  arr
end
##

def history_update(info)
  path = File.expand_path('data/history.yml', __dir__)
  data = YAML.load_file(path)

    if data.size == 100
      data.shift(10)
      time = Time.now.utc.localtime('+09:00').to_s + " " + info
    else
      time = Time.now.utc.localtime('+09:00').to_s + " " + info
    end
    data << time
    File.write('data/history.yml', YAML.dump(data))
  @history = YAML.load_file(path)
end

# ##################

not_found do
  redirect '/'
end

get '/backup/:files'do

  require_user_signin
  files = params[:files]

  unless File.directory?('./backup') #creates a folder if it doesn't exist
    Dir.mkdir './backup'
  end

  if files.include?('unit')
    path = './backup/unit_imgs.zip'
    File.delete(path) if File.exist?(path)

    zip_it(path)
    fname = 'unit_imgs.zip'
    ftype = 'Application/octet-stream'
    send_file "./backup/#{fname}", filename: fname, type: ftype

  elsif files.include?('sc')
    path = './backup/sc_imgs.zip'
    File.delete(path) if File.exist?(path)
    zip_it(path)

    fname = '/sc_imgs.zip'
    ftype = 'Application/octet-stream'
    send_file "./backup/#{fname}", filename: fname, type: ftype
  end
  redirect '/'
end

get '/users/signin' do
  erb :signin
end

def format_sc
  scs = load_soulcards_details
  scs.each do |k, v|
    v['normal'] = [[v['stats']],['']]
    v['prism'] = [[v['stats']],['']]
    v.delete_if {|key, value| key == 'stats' }
    # binding.pry
  end
  File.write('data/sc/soul_cards.yml', YAML.dump(scs))

  # binding.pry
end

get '/form' do
  format_sc
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

get '/search' do
  keys = params[:search_query].downcase
  # @named_units = get_unit_or_sc_from_keys(keys)[0]
  @by_name = search_stats_for_key(@units, keys, 'names')

  units = get_unit_or_sc_from_keys(keys)[0]
  @units = exclude_specific_profiles_from_list(units, keys)

  @soulcards = get_unit_or_sc_from_keys(keys)[1]
  erb :search
end
# method to add enabled key to YML files. Not needed when finished
def add_enabled_key
  @scs = load_soulcards_details
  @uts = load_unit_details
  binding.pry
  @scs.each do |k, v|
    v['enabled'] = 'true'
  end
  File.write('data/sc/soul_cards.yml', YAML.dump(@scs))
  @uts.each do |k, v|
    v['enabled'] = 'true'
  end
  binding.pry
  File.write('data/unit_details.yml', YAML.dump(@uts))
end
###########

get '/' do
  @new_units = select_enabled_profiles(@units).sort_by {|k,v| [v['date'], k]}.last(5).to_h
  @new_soulcards = select_enabled_profiles(@soulcards).to_a.last(4).to_h
  erb :home
end

get '/basics' do

  path = File.expand_path('data/history.yml', __dir__)
  @history = YAML.load_file(path)

  path = File.expand_path('data/basics.md', __dir__)
  @markdown = load_file_content(path)
  erb :starterguide
end

get '/:filename/edit' do
  file = File.expand_path("data/#{params[:filename]}.yml", __dir__)
  @name = params[:filename]
  begin
    @content = YAML.dump(YAML.load_file(file))
  rescue Psych::SyntaxError => ex
    p ex.file
    p ex.message
  end
  # @content = YAML.dump(YAML.load_file(file))

  erb :edit_notice
end

get '/download/:filename' do |filename|
  fname = filename
  ftype = 'Application/octet-stream'
  # checked_fname = filename.split('').map(&:to_i).reduce(&:+) == 0
  if filename.include?('soul')
    send_file "./data/sc/#{filename}", filename: fname, type: ftype
  elsif filename.include?('unit') ||
        filename.include?('maininfo') ||
        filename.include?('basics.md') ||
        filename.include?('history')
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
  @max_index_val = get_max_index_number(@soulcards)
  erb :new_sc
end

get '/new_unit' do
  require_user_signin
  @new_unit_info = @new_unit
  @max_index_val = get_max_index_number(@units)
  erb :new_unit
end

get '/:catagory/:star_rating' do
  star_rating = params[:star_rating]

  if ![5, 4, 3].include?(star_rating[0].to_i)
    session[:message] = 'There are no units or soulcards by that tier!'
    redirect '/'
  end

  if params[:catagory] == 'childs'
    unit_info = select_enabled_profiles(@units)
    @catagory = 'childs'
    @units = sort_by_given_info(unit_info, params[:star_rating])
    erb :index_child
  else
    unit_info = select_enabled_profiles(@soulcards)
    @catagory = 'equips'
    @cards = sort_by_given_info(unit_info, params[:star_rating])
    erb :index_sc
  end
end

get '/childs/:star_rating/:unit_name' do
  name = params[:unit_name]
  unit_or_sc_exist?('unit', name)
  @unit_name = name
  @current_unit = @units[name]
  erb :view_unit
end

get '/childs/:star_rating/:unit_name/edit' do
  require_user_signin
  name = params[:unit_name]
  @unit_name = name
  @current_unit = @units[name]
  erb :edit_unit
end

get '/equips/:star_rating/:sc_name' do
  name = params[:sc_name]
  unit_or_sc_exist?('soulcard', name)
  @sc_name = name
  @current_card = @soulcards[name]
  erb :view_sc
end

get '/equips/:star_rating/:sc_name/edit' do
  require_user_signin
  name = params[:sc_name]
  @card_name = name
  @current_card = @soulcards[name]
  erb :edit_sc
end

get '/childs/:star_rating/sort_by/:type' do
  @star_rating = params[:star_rating]
  @catagory_type = params[:type]
  unit_info = select_enabled_profiles(@units)

  if %w[3 4 5].any? { |star| star == @star_rating[0] }
    @catagories = sort_by_and_select_type(unit_info, @catagory_type)
    @units =
      sort_by_given_info(unit_info, @star_rating, @catagories, @catagory_type)

    return erb :sort_by_tier if @catagory_type == 'tier'
  elsif @star_rating == 'all'
    @catagories = sort_by_and_select_type(unit_info, @catagory_type)
    @units =
      sort_by_given_info(unit_info, @star_rating, @catagories, @catagory_type)

    return erb :sort_by_tier if @catagory_type == 'tier'
  else
    session[:message] = 'There are no units by that tier!'
    redirect '/'
  end
  erb :sort_by_type
end

get '/show_unit_details' do
  @unit_details = select_enabled_profiles(@units)
  @disabled_units = select_disabled_profiles(@units)
  @sc_details = select_enabled_profiles(@soulcards)
  @disabled_sc = select_disabled_profiles(@soulcards)
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
  card_data = @soulcards

  @current_unit = card_data[params[:sc_name]]
  @max_index_val = get_max_index_number(card_data)

  data = card_data
  name = params[:sc_name].downcase
  index = params[:index].to_i

  original_card = card_data.select do |unit, info|
    unit if index == info['index'].to_i
  end

  pname = create_file_from_upload(params[:file], params[:pic], 'public/images/sc')

  if card_data.include?(name) && index != card_data[name]['index']
    session[:message] =
      'A card by that name already exists. Please create a different card.'
    status 422

    if params['edited']
      temp_name = get_unit_name(card_data, index)
      redirect "/equips/#{params[:stars]}stars/#{temp_name}/edit"
    else
      redirect '/equips/new_sc'
    end

  else
    data.delete(original_card.keys.first)
    data[name] = {}
  end

  data[name]['pic'] = pname.include?('.') ? pname : (pname + '.jpg')
  data[name]['enabled'] = if params[:enabled]
                            'false'
                          else
                            'true'
                          end
  data[name]['stars'] = params[:stars]
  data[name]['normal'] = format_input_stats(params[:normal])
  if data[name]['stars'] == '5'
    data[name]['prism'] = format_input_stats(params[:prism])
    # binding.pry
    # data[name]['prism'] =
    #  if params[:prism] == ''
    #    data[name]['normal']
    #  else
    #   format_input_stats(params[:prism])
    #  end
   end
  data[name]['passive'] = format_input_stats(params[:passive], true)
  data[name]['index'] = index

  File.write('data/sc/soul_cards.yml', YAML.dump(data))
  session[:message] = "New Soulcard called #{name.upcase} has been created."
  history_update(session[:message])
  redirect "/equips/#{params[:stars]}stars/#{name.gsub(' ', '%20')}"
end

post '/new_unit' do
  require_user_signin
  unit_data = @units

  @new_unit_name = params[:new_unit_name].downcase
  @original_name = params[:current_unit_name] ? params[:current_unit_name].downcase : ''
  @current_unit = unit_data.select{ |name, details| [name => details] if name == @new_unit_name }
  @max_index_val = get_max_index_number(unit_data)

  data = unit_data
  name = @new_unit_name == '' ? @original_name : @new_unit_name
  index = params[:index].to_i
  date = check_and_fetch_date(data, @original_name)

  original_unit = unit_data.select do |unit, info|
    unit if params['index'].to_i == info['index'].to_i && unit == @original_name
  end

  pname = create_file_from_upload(params[:file], params[:pic], 'public/images')

  if (unit_data.include?(@original_name) && index != unit_data[@original_name]['index']) ||
     (unit_data.include?(@new_unit_name) && index != unit_data[@new_unit_name]['index'])

    session[:message] =
      'A unit by that name already exists. Please enter a different unit name.'
    status 422

    if params['edited']
      temp_name = get_unit_name(unit_data, index)
      redirect "/childs/#{params[:stars]}stars/#{temp_name}/edit".gsub(' ', '%20')
    else
      redirect '/new_unit'
    end
  else
    data.delete(original_unit.keys.first)
    data[name] = {}
  end

  data[name]['pic'] = pname.include?('.') ? pname : (pname + '.png')

  %w(pic2 pic3).each do |param_name|
    data[name][param_name] =
      if params[param_name.to_sym] == ''
        params[param_name.to_sym]
      else
        temp_pic_n = params[param_name.to_sym].gsub('/images/', '').gsub('.png', '')
        '/images/' + temp_pic_n + '.png'
      end
  end

  data[name]['enabled'] = if params[:enabled]
                            'false'
                          else
                            'true'
                          end
  data[name]['stars'] = params[:stars]
  data[name]['type'] = params[:type]
  data[name]['element'] = params[:element]
  data[name]['tier'] = params[:tier]

  if (params[:skillsdump].nil? || params[:skillsdump].empty?)
    data[name]['leader'] = params[:leader]
    data[name]['auto'] = params[:auto]
    data[name]['tap'] = params[:tap]
    data[name]['slide'] = params[:slide]
    data[name]['drive'] = params[:drive]
  else
    data[name]['leader'], data[name]['auto'],
    data[name]['tap'], data[name]['slide'], data[name]['drive'] =
    skills_splitter(params[:skillsdump])
  end
  data[name]['notes'] = params[:notes]
  data[name]['date'] = if date == ''
                         new_time = Time.now.utc.localtime('+09:00')
                         [new_time.year, new_time.month, new_time.day].join('-')
                       else
                         date
                       end
  data[name]['index'] = index

  File.write('data/unit_details.yml', YAML.dump(data))
  session[:message] = "New unit called #{name.upcase} has been created."
  history_update(session[:message])
  redirect "/childs/#{params[:stars]}stars/#{name.gsub(' ', '%20')}"
end

get '/childs/:star_rating/:unit_name/remove' do
  require_user_signin
  unit = params[:unit_name]
  units_info = @units

  if units_info.include?(params[:unit_name]) == false
    status 422
    session[:message] = "That unit doesn't exist."
  else
    units_info.delete(unit)
    File.write('data/unit_details.yml', YAML.dump(units_info))
    session[:message] = "#{unit.upcase} unit was successfully deleted."
    history_update(session[:message])
  end
  redirect '/'
end

get '/equips/:star_rating/:sc_name/remove' do
  require_user_signin
  card = params[:sc_name]
  cards_info = @soulcards

  if cards_info.include?(params[:sc_name]) == false
    status 422
    session[:message] = "That unit doesn't exist."
  else
    cards_info.delete(card)
    File.write('data/sc/soul_cards.yml', YAML.dump(cards_info))
    session[:message] = "#{card.upcase} SoulCard successfully deleted."
    history_update(session[:message])
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
  history_update("File uploaded: #{name}")
  erb :upload
end

post '/update/:filename' do
  name = params[:filename] + '.yml'
  content = params[:content].gsub("script", '')
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
