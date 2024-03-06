require 'rack'
require 'json'
require_relative 'test'

class Server
  def call(env)
    req = Rack::Request.new(env)
    path = req.path_info
    headers = { 'content-type' => 'application/json' }

    case path
    when '/tests'
      tests = Test.all.to_json
      [200, headers, [tests]]
    else
      [404, headers, ['Not found']]
    end
  end
end
