require 'uri'

require_relative 'svg'

def new_badge(owner, project, name, data)
  full_name = "#{owner}/#{project}/#{name}"

  subject = data.key?('subject') ? data['subject'] : name

  Badge.new(owner: owner, project: project, name: name, full_name: full_name,
            image: svg(subject, URI.decode(data['status']), data['color']),
            created_at: DateTime.now)
end
