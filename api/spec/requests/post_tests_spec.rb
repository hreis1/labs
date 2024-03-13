require 'spec_helper'

describe 'POST /api/import' do
  it 'importa um csv' do
    csv = 'spec/support/data.csv'
    spy_import_job = spy('ImportJob')
    stub_const('ImportJob', spy_import_job)

    file = Rack::Test::UploadedFile.new(csv, 'text/csv')
    post '/api/import', file: file

    expect(ImportJob).to have_received(:perform_async).with(file.tempfile.read)
    expect(last_response).to be_created
    expect(last_response.content_type).to eq('application/json')
    expect(JSON.parse(last_response.body)).to eq('message' => 'Exams imported')
  end

  it 'não importa um csv' do
    post '/api/import'

    expect(last_response).to be_bad_request
    expect(last_response.content_type).to eq('application/json')
    expect(JSON.parse(last_response.body)).to eq('error' => 'Invalid file')
  end
end
