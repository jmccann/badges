require 'sinatra'
require 'json'

require_relative '../helpers/datamapper'
require_relative '../helpers/data'

post '/badges/:owner/:project/:name' do |owner, project, name|
  full_name = "#{owner}/#{project}/#{name}"
  badge = Badge.new(owner: owner, project: project, name: name,
                    full_name: full_name,
                    created_at: DateTime.now)

  # After creating object return details of it
  redirect "/badges/#{badge.full_name}" if badge.save

  error = badge.errors.full_messages.join(', ')
  return [500, { message: "Failed to create new Badge: #{error}" }.to_json]
end
