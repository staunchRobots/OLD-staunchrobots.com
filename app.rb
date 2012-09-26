require "sinatra"
require "sinatra/reloader"
require "sinatra/activerecord"
require 'sinatra/partial'
require "sinatra/base"
# require "active_record"
require "uri"
require "haml"
require "bundler/setup"
require "logger"
require "ap"

# App
require "./helpers.rb"
require "./models.rb"
require "./github.rb"

# dbconfig = YAML.load(File.read("config/database.yml"))
RACK_ENV ||= ENV["RACK_ENV"] || "development"
PER_PAGE = 6
# ActiveRecord::Base.establish_connection dbconfig[RACK_ENV]
Dir.mkdir('log') if !File.exists?('log') || !File.directory?('log')
ActiveRecord::Base.logger = Logger.new(File.open("log/#{RACK_ENV}.log", "a+"))
ActiveRecord::Base.logger.level = Logger::DEBUG


## actions ##

  get '/' do
    haml :index
  end

  [:index, :jobs, :learn, :"team-page", :technology, :work].each do |page|
    get "/#{page}*" do
      haml page
    end
  end

  get "/team" do
    @events = HubEvents.team_events
    haml :team
  end

  post "/apply_for_dojo" do
    @email = params[:applicant_email]
    @study = params[:applicant_study]
    @kohai = Applicant.new(:email => @email, :study => @study)
    @flash ||= {}
    if @kohai.save
      @flash[@study] = "We got you! You will be notified about new upcoming Dojo events"
    else
      @flash[@study] = "Correct following errors: #{@kohai.errors.full_messages.join(', ')}"
    end
    haml :learn
  end

  get '/hack' do
    protected!
    @applicants = Applicant.all
    haml :hack
  end

