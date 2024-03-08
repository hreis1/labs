require 'sinatra'
require_relative './models/exam'

get '/api/tests' do
  content_type :json
  Exam.all.to_json
end
