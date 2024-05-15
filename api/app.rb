require './lib/import_job'
require './models/exam'
require 'sinatra'

get '/api/tests' do
  headers 'Access-Control-Allow-Origin' => 'http://localhost:3001'
  content_type :json
  page = params[:page] || 1
  per_page = params[:per_page] || 10
  exams = Exam.paginate(page: page, per_page: per_page)
  exams.to_json
end

get '/api/tests/:token' do
  headers 'Access-Control-Allow-Origin' => 'http://localhost:3001'
  content_type :json
  exam = Exam.find_by_result_token(result_token: params[:token])
  return exam.to_json if exam

  status 404
  { error: 'Exam not found' }.to_json
end

post '/api/import' do
  content_type :json
  headers 'Access-Control-Allow-Origin' => 'http://localhost:3001'
  begin
    csv = if params[:file]
            params[:file][:tempfile].read
          else
            request.body.read
          end

    raise 'Invalid file' unless Import.valid?(csv: csv)

    ImportJob.perform_async(csv)
    status 201
    { message: 'Exams imported' }.to_json
  rescue StandardError => e
    status 400
    { error: e.message }.to_json
  end
end
