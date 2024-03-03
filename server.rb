require 'sinatra'
require 'pg'
require_relative 'test'

set :server, :puma
set :port, 3000
set :bind, '0.0.0.0'

conn = PG.connect(
  host: ENV['DB_HOST'] || 'localhost',
  password: 'postgres',
  user: 'postgres',
  dbname: 'postgres'
)

get '/tests' do
  content_type :json
  result = Test.all
  result.to_json
end

get '/' do
  'Hello world!'
end
