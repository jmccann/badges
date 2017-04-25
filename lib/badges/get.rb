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
  get_badge(owner, project, name, nil)
end

#
# Return badge
#
get '/badges/:owner/:project/:name/badge.svg' do |owner, project, name|
  get_badge_svg(owner, project, name, nil)
end

#
# Show badge details for a branch
#
get '/badges/:owner/:project/:name/:branch' do |owner, project, name, branch|
  get_badge(owner, project, name, branch)
end

#
# Return badge for a branch
#
get '/badges/:owner/:project/:name/:branch/badge.svg' do |owner, project, name, branch| # rubocop:disable LineLength
  get_badge_svg(owner, project, name, branch)
end

def get_badge(owner, project, name, branch = nil)
  badge = Badge.all(owner: owner, project: project, name: name, branch: branch)
  return [200, badge.first.to_json] if badge.count == 1
  [500, message: "Too many badges returned: #{badge.count}"] if badge.count > 1
end

def get_badge_svg(owner, project, name, branch = nil)
  content_type 'image/svg+xml'
  badge = Badge.all(owner: owner, project: project, name: name, branch: branch)
  return [200, badge.first.image] if badge.count == 1
  [500, message: "Too many badges returned: #{badge.count}"] if badge.count > 1
end

def redirect_badge_details(badge, branch = nil)
  url = "/badges/#{badge.full_name}"
  url += "/#{badge.branch}" unless branch.nil?
  redirect url if badge.save
end
