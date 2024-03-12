require 'sinatra'

get '/' do
  File.open('index.html')
end

set :bind, '0.0.0.0'
set :port, 3001
