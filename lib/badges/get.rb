require 'sinatra'
require 'json'

require_relative '../helpers/datamapper'

#
# Show all badges
#
get '/badges' do
  badges = Badge.all
  [200, badges.map { |b| "#{b.owner}/#{b.project}/#{b.name}" }.to_json]
end

#
# Show all badges for an owner
#
get '/badges/:owner' do |owner|
  badges = Badge.all(owner: owner)
  [200, badges.to_json]
end

#
# Show all badges for an owner/project
#
# TBD
#

#
# Show badge details
#
get '/badges/:owner/:project/:name' do |owner, project, name|
  badge = Badge.all(owner: owner, project: project, name: name, branch: nil)
  return [200, badge.first.to_json] if badge.count == 1
  [500, message: "Too many badges returned: #{badge.count}"] if badge.count > 1
end

#
# Return badge
#
get '/badges/:owner/:project/:name/badge.svg' do |owner, project, name|
  content_type 'image/svg+xml'
  badge = Badge.all(owner: owner, project: project, name: name, branch: nil)
  return [200, badge.first.image] if badge.count == 1
  [500, message: "Too many badges returned: #{badge.count}"] if badge.count > 1
end

#
# Show badge details for a branch
#
get '/badges/:owner/:project/:name/:branch' do |owner, project, name, branch|
  badge = Badge.all(owner: owner, project: project, name: name, branch: branch)
  return [200, badge.first.to_json] if badge.count == 1
  [500, message: "Too many badges returned: #{badge.count}"] if badge.count > 1
end

#
# Return badge for a branch
#
get '/badges/:owner/:project/:name/:branch/badge.svg' do |owner, project, name, branch| # rubocop:disable LineLength
  content_type 'image/svg+xml'
  badge = Badge.all(owner: owner, project: project, name: name, branch: branch)
  return [200, badge.first.image] if badge.count == 1
  [500, message: "Too many badges returned: #{badge.count}"] if badge.count > 1
end
