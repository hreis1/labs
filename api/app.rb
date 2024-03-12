require './lib/import_job'
require './models/exam'
require 'sinatra'

get '/api/tests' do
  headers 'Access-Control-Allow-Origin' => '*'
  content_type :json
  Exam.all.to_json
end

get '/api/tests/:token' do
  headers 'Access-Control-Allow-Origin' => '*'
  content_type :json
  exam = Exam.find_by_result_token(result_token: params[:token])
  return exam.to_json if exam

  status 404
  { error: 'Exam not found' }.to_json
end

post '/api/import' do
  content_type :json
  headers 'Access-Control-Allow-Origin' => '*'
  begin
    csv = if params[:file]
            params[:file][:tempfile].read
          else
            request.body.read
          end

    raise 'Invalid file' if csv.empty?

    ImportJob.perform_async(csv)
    status 201
    { message: 'Exams imported' }.to_json
  rescue StandardError => e
    status 400
    { error: e.message }.to_json
  end
end
