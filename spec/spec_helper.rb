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

def test_svg # rubocop:disable MethodLength
  '<svg xmlns="http://www.w3.org/2000/svg" width="66" height="20">' \
  '<linearGradient id="b" x2="0" y2="100%">' \
  '<stop offset="0" stop-color="#bbb" stop-opacity=".1"/>' \
  '<stop offset="1" stop-opacity=".1"/></linearGradient><mask id="a">' \
  '<rect width="66" height="20" rx="3" fill="#fff"/></mask><g mask="url(#a)">' \
  '<path fill="#555" d="M0 0h31v20H0z"/>' \
  '<path fill="#97CA00" d="M31 0h35v20H31z"/>' \
  '<path fill="url(#b)" d="M0 0h66v20H0z"/></g>' \
  '<g fill="#fff" text-anchor="middle" ' \
  'font-family="DejaVu Sans,Verdana,Geneva,sans-serif" font-size="11">' \
  '<text x="15.5" y="15" fill="#010101" fill-opacity=".3">test</text>' \
  '<text x="15.5" y="14">test</text>' \
  '<text x="47.5" y="15" fill="#010101" fill-opacity=".3">97%</text>' \
  '<text x="47.5" y="14">97%</text></g></svg>'
end

def test_svg_27 # rubocop:disable MethodLength
  '<svg xmlns="http://www.w3.org/2000/svg" width="66" height="20">' \
  '<linearGradient id="b" x2="0" y2="100%">' \
  '<stop offset="0" stop-color="#bbb" stop-opacity=".1"/>' \
  '<stop offset="1" stop-opacity=".1"/></linearGradient><mask id="a">' \
  '<rect width="66" height="20" rx="3" fill="#fff"/></mask><g mask="url(#a)">' \
  '<path fill="#555" d="M0 0h31v20H0z"/>' \
  '<path fill="#97CA00" d="M31 0h35v20H31z"/>' \
  '<path fill="url(#b)" d="M0 0h66v20H0z"/></g>' \
  '<g fill="#fff" text-anchor="middle" ' \
  'font-family="DejaVu Sans,Verdana,Geneva,sans-serif" font-size="11">' \
  '<text x="15.5" y="15" fill="#010101" fill-opacity=".3">test</text>' \
  '<text x="15.5" y="14">test</text>' \
  '<text x="47.5" y="15" fill="#010101" fill-opacity=".3">27%</text>' \
  '<text x="47.5" y="14">27%</text></g></svg>'
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/badges.db")
  DataMapper.finalize
  Badge.auto_migrate!

  config.before(:each) do
    Badge.all.destroy
    Badge.new(owner: 'jmccann', project: 'app1', image: test_svg,
              name: 'coverage', full_name: 'jmccann/app1/coverage',
              created_at: DateTime.now).save
    Badge.new(owner: 'jmccann', project: 'app1', image: test_svg,
              name: 'climate', full_name: 'jmccann/app1/climate',
              created_at: DateTime.now).save
    Badge.new(owner: 'jmccann', project: 'app2', image: test_svg,
              name: 'coverage', full_name: 'jmccann/app2/coverage',
              created_at: DateTime.now).save
    Badge.new(owner: 'jdoe', project: 'app1', image: test_svg,
              name: 'coverage', full_name: 'jdoe/app1/coverage',
              created_at: DateTime.now).save
  end
end

def app
  Sinatra::Application
end

Capybara.app = app
