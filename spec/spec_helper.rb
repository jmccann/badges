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

  config.before(:each) do
    Badge.all.destroy
    Badge.new(owner: 'jmccann', project: 'app1', image: '1',
              name: 'coverage', created_at: DateTime.now).save
    Badge.new(owner: 'jmccann', project: 'app1', image: '1',
              name: 'climate', created_at: DateTime.now).save
    Badge.new(owner: 'jmccann', project: 'app2', image: '1',
              name: 'coverage', created_at: DateTime.now).save
    Badge.new(owner: 'jdoe', project: 'app1', image: '1',
              name: 'coverage', created_at: DateTime.now).save
  end
end

def app
  Sinatra::Application
end

Capybara.app = app
