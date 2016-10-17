require 'sinatra'
require 'json'
require 'uri'

require_relative '../helpers/datamapper'
require_relative '../helpers/data'
require_relative '../helpers/svg'

put '/badges/:owner/:project/:name' do |owner, project, name|
  subject = data.key?('subject') ? data['subject'] : name

  badges = Badge.all(owner: owner, project: project, name: name)
  if badges.count > 1
    return [500, message: "Expected 1 badge, got #{badges.count}"]
  end

  badge = nil
  if badges.count.zero?
    badge = new_badge(owner, project, name, data)
  else
    badge = badges.first
    badge.image = svg(subject, URI.decode(data['status']), data['color'])
  end

  # After creating object return details of it
  redirect "/badges/#{badge.full_name}" if badge.save

  error = badge.errors.full_messages.join(', ')
  return [500, { message: "Failed to update the Badge: #{error}" }.to_json]
end
