require 'sinatra'
require 'json'
require 'open-uri'

require_relative '../helpers/datamapper'
require_relative '../helpers/data'

def badge_url(subject, status, color)
  query = "#{subject}-#{status}-#{color}"
  URI.encode "https://img.shields.io/badge/#{query}.svg"
end

post '/badges/:owner/:project/:name' do |owner, project, name|
  subject = data.key?('subject') ? data['subject'] : name
  url = badge_url(subject, data['status'], data['color'])
  svg = open(url).read

  full_name = "#{owner}/#{project}/#{name}"
  badge = Badge.new(owner: owner, project: project, name: name,
                    full_name: full_name, image: svg,
                    created_at: DateTime.now)

  # After creating object return details of it
  redirect "/badges/#{badge.full_name}" if badge.save

  error = badge.errors.full_messages.join(', ')
  return [500, { message: "Failed to create new Badge: #{error}" }.to_json]
end
