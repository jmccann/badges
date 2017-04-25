require 'sinatra'
require 'json'

require_relative '../helpers/datamapper'
require_relative '../helpers/data'

post '/badges/:owner/:project/:name' do |owner, project, name|
  post_badge(owner, project, name, data, nil)
end

post '/badges/:owner/:project/:name/:branch' do |owner, project, name, branch|
  post_badge(owner, project, name, data, branch)
end

def post_badge(owner, project, name, data, branch = nil)
  badge = new_badge(owner, project, name, data, branch)

  # After creating object return details of it
  redirect_badge_details badge, branch

  error = badge.errors.full_messages.join(', ')
  [500, { message: "Failed to create new Badge: #{error}" }.to_json]
end
