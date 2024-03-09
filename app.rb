require 'sinatra'
require_relative './models/exam'

get '/api/tests' do
  content_type :json
  Exam.all.to_json
end

get '/api/tests/:token' do
  content_type :json
  exam = Exam.find_by_result_token(result_token: params[:token])
  return exam.to_json if exam
  status 404
  { error: 'Exam not found' }.to_json
end
