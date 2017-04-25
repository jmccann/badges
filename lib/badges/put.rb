require 'sinatra'
require 'json'
require 'uri'

require_relative '../helpers/datamapper'
require_relative '../helpers/data'
require_relative '../helpers/svg'

put '/badges/:owner/:project/:name' do |owner, project, name|
  put_badge(owner, project, name, nil)
end

put '/badges/:owner/:project/:name/:branch' do |owner, project, name, branch|
  put_badge(owner, project, name, branch)
end

def put_badge(owner, project, name, branch = nil) # rubocop:disable AbcSize, MethodLength, LineLength
  subject = data.key?('subject') ? data['subject'] : name

  badges = Badge.all(owner: owner, project: project, name: name, branch: branch)
  if badges.count > 1
    return [500, message: "Expected 1 badge, got #{badges.count}"]
  end

  badge = nil
  if badges.count.zero?
    badge = new_badge(owner, project, name, data, branch)
  else
    badge = badges.first
    badge.image = svg(subject, URI.decode(data['status'].to_s), data['color'])
  end

  # After creating object return details of it
  redirect_badge_details badge, branch

  error = badge.errors.full_messages.join(', ')
  [500, { message: "Failed to update the Badge: #{error}" }.to_json]
end
