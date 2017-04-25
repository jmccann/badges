require 'sinatra'
require 'json'

require_relative '../helpers/datamapper'

delete '/badges/:owner/:project/:name' do |owner, project, name|
  delete_badge(owner, project, name, nil)
end

delete '/badges/:owner/:project/:name/:branch' do |owner, project, name, branch|
  delete_badge(owner, project, name, branch)
end

def delete_badge(owner, project, name, branch = nil) # rubocop:disable MethodLength, LineLength
  badge = Badge.all(owner: owner, project: project, name: name, branch: branch)

  if badge.count == 1
    badge.destroy!
    return [204]
  end

  if badge.count > 1
    error = 'Failed to delete badge. ' \
            "Expected only 1 badge but got: #{badge.count}"
    return [500, { message: error }.to_json]
  end

  if badge.count.zero?
    error = "No matching badge for #{owner}/#{project}/#{name}"
    error += "/#{branch}" unless branch.nil?
    return [500, { message: error }.to_json]
  end

  [500, { message: 'Unknown error' }.to_json]
end
