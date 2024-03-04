require 'sinatra'
require_relative 'test'

set :server, :puma
set :port, 3000
set :bind, '0.0.0.0'

get '/tests' do
  content_type :json
  result = Test.all
  result.to_json
end

get '/' do
  'Hello world!'
end
