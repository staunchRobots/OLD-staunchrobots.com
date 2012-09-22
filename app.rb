require "sinatra"
require "sinatra/reloader"
require "sinatra/activerecord"
require "sinatra/base"
# require "active_record"
require "uri"
require "haml"
require "bundler/setup"
require "logger"

# App
require "./helpers.rb"
require "./models.rb"

# dbconfig = YAML.load(File.read("config/database.yml"))
RACK_ENV ||= ENV["RACK_ENV"] || "development"
PER_PAGE = 6
# ActiveRecord::Base.establish_connection dbconfig[RACK_ENV]
Dir.mkdir('log') if !File.exists?('log') || !File.directory?('log')
ActiveRecord::Base.logger = Logger.new(File.open("log/#{RACK_ENV}.log", "a+"))


## actions ##

  get '/' do
    haml :index
  end

  [:index, :jobs, :learn, :"team-page", :team, :technology, :work].each do |page|
    get "/#{page}*" do
      haml page
    end
  end

  post "/apply_for_dojo" do
    @email = params[:applicant_email]
    @kohai = Applicant.new(:email => @email)
    if @kohai.save
      @flash = "We got you! You will be notified about new upcoming Dojo events"
    else
      @flash = "Correct following errors: #{@kohai.errors.full_messages.join(', ')}"
    end
    haml :learn
  end

  get '/hack' do
    protected!
    @applicants = Applicant.all
    haml :hack
  end

