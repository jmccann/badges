require 'sinatra'
require 'json'

require_relative '../helpers/datamapper'
require_relative '../helpers/data'

post '/badges' do
  extra_data = {
    full_name: "#{data['owner']}/#{data['project']}/#{data['name']}",
    created_at: DateTime.now
  }

  badge = Badge.new(data.merge(extra_data))

  # After creating object return details of it
  redirect "/badges/#{badge.full_name}" if badge.save

  error = badge.errors.full_messages.join(', ')
  return [500, { message: "Failed to create new Badge: #{error}" }.to_json]
end
