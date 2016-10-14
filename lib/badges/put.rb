require 'sinatra'
require 'json'
require 'open-uri'

require_relative '../helpers/datamapper'
require_relative '../helpers/data'

def badge_url(subject, status, color)
  query = "#{subject}-#{status}-#{color}"
  "https://img.shields.io/badge/#{query}.svg"
end

put '/badges/:owner/:project/:name' do |owner, project, name|
  subject = data.key?('subject') ? data['subject'] : name
  url = badge_url(subject, data['status'], data['color'])

  badges = Badge.all(owner: owner, project: project, name: name)
  if badges.count > 1
    return [500, message: "Expected 1 badge, got #{badges.count}"]
  end

  badge = nil
  if badges.count.zero?
    full_name = "#{owner}/#{project}/#{name}"
    badge = Badge.new(owner: owner, project: project, name: name,
                      full_name: full_name, image: open(url).read,
                      created_at: DateTime.now)
  else
    badge = badges.first
    badge.image = open(url).read
  end

  # After creating object return details of it
  redirect "/badges/#{badge.full_name}" if badge.save

  error = badge.errors.full_messages.join(', ')
  return [500, { message: "Failed to update the Badge: #{error}" }.to_json]
end
