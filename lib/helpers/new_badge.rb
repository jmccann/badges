require 'open-uri'

def badge_url(subject, status, color)
  query = "#{subject}-#{status}-#{color}"
  "https://img.shields.io/badge/#{query}.svg"
end

def new_badge(owner, project, name, data)
  full_name = "#{owner}/#{project}/#{name}"

  subject = data.key?('subject') ? data['subject'] : name
  url = badge_url(subject, data['status'], data['color'])

  Badge.new(owner: owner, project: project, name: name,
            full_name: full_name, image: open(url).read,
            created_at: DateTime.now)
end
