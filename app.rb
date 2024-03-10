require_relative './lib/import'
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
    csv = if params[:file]
            params[:file][:tempfile].read
          else
            request.body.read
          end

    raise 'Invalid file' if csv.empty?

    import_from_csv(csv:)
    { message: 'Exams imported' }.to_json
  rescue StandardError
    status 400
    { error: 'Invalid file' }.to_json
  end
end
