require 'sinatra'
require 'pg'

conn = PG.connect(
  host: 'postgres',
  password: 'postgres',
  user: 'postgres',
  dbname: 'postgres'
)

get '/tests' do
  content_type :json
  result = conn.exec('SELECT * FROM tests').to_a
  result.to_json
end

get '/' do
  'Hello world!'
end
