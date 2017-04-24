require 'uri'

require_relative 'svg'

def new_badge(owner, project, name, data, branch = nil)
  full_name = "#{owner}/#{project}/#{name}"

  subject = data.key?('subject') ? data['subject'] : name

  Badge.new(owner: owner, project: project, name: name, full_name: full_name,
            branch: branch, created_at: DateTime.now,
            image: svg(subject, URI.decode(data['status']), data['color']))
end
