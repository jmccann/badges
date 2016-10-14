require 'sinatra'

# Files to load
Dir['lib/**/*.rb'].each do |file|
  require ::File.expand_path("../#{file.gsub('.rb', '')}", __FILE__)
end

set :app_file, __FILE__

run Sinatra::Application
