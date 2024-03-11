require 'spec_helper'

describe 'import_from_csv' do
  it 'com sucesso' do
    csv = File.open('spec/support/data.csv')
    import_from_csv(csv:)

    expect(Exam.all.count).to eq 1
    expect(Database.connection.exec('SELECT * FROM patients').count).to eq 1
    expect(Database.connection.exec('SELECT * FROM doctors').count).to eq 1
    expect(Database.connection.exec('SELECT * FROM tests').count).to eq 13
  end
end
