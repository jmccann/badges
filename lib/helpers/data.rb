def request_body
  @request_body ||= begin
    request.body.rewind # in case someone already read it
    request.body.read
  end
end

def data
  @data ||= begin
    request_body.nil? || request_body.empty? ? {} : JSON.parse(request_body)
  end
end
