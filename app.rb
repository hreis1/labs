require_relative './models/import'
require_relative './models/exam'
require 'sinatra'

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

post '/api/import' do
  content_type :json
  begin
    status 201
    import_from_csv(file: params[:file][:tempfile])
    { message: 'Exams imported' }.to_json
  rescue
    status 400
    { error: 'Invalid file' }.to_json
  end
end
