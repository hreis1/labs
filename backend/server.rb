require 'rack'
require 'json'

class Server
  def call(env)
    req = Rack::Request.new(env)
    path = req.path_info
    headers = Hash.new
    headers['content-type'] = 'application/json'
    headers['access-control-allow-origin'] = '*'

    case path
    when '/tests'
      exams = [].to_json
      [200, headers, [exams]]
    else
      [404, headers, ['Not found']]
    end
  end
end
