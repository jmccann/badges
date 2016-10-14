require 'pry'
require 'sinatra'
require 'rack/test'
require 'capybara/rspec'
require 'simplecov'
SimpleCov.start do
  add_filter '.bundler/'
  add_filter 'spec/'
end

# If RACK_ENV isn't set, set it to 'test'.  Sinatra defaults to development,
# so we have to override that unless we want to set RACK_ENV=test from the
# command line when we run rake spec.  That's tedious, so do it here.
ENV['RACK_ENV'] ||= 'test'

Dir['lib/**/*.rb'].each do |file|
  require ::File.expand_path("../../#{file.gsub('.rb', '')}", __FILE__)
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/badges.db")
  DataMapper.finalize
  Badge.auto_migrate!
end

def app
  Sinatra::Application
end

Capybara.app = app
