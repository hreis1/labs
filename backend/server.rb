require 'rack'
require 'json'
require_relative 'models/exam'

class Server
  def call(env)
    req = Rack::Request.new(env)
    path = req.path_info
    headers = Hash.new
    headers['content-type'] = 'application/json'
    headers['access-control-allow-origin'] = '*'

    case path
    when '/tests'
      exams = Exam.all
      [200, headers, [exams.to_json]]
    else
      [404, headers, ['Not found']]
    end
  end
end
