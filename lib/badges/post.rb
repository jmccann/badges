require 'sinatra'
require 'json'

require_relative '../helpers/datamapper'
require_relative '../helpers/data'

post '/badges/:owner/:project/:name' do |owner, project, name|
  badge = new_badge(owner, project, name, data)

  # After creating object return details of it
  redirect "/badges/#{badge.full_name}" if badge.save

  error = badge.errors.full_messages.join(', ')
  return [500, { message: "Failed to create new Badge: #{error}" }.to_json]
end
