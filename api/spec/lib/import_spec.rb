require 'spec_helper'

describe '#import_from_csv' do
  it 'com sucesso' do
    csv = File.read('spec/support/data.csv')
    import_from_csv(csv: csv)
    expect(Database.connection.exec('SELECT * FROM patients').count).to eq(1)
    expect(Database.connection.exec('SELECT * FROM doctors').count).to eq(1)
    expect(Database.connection.exec('SELECT * FROM exams').count).to eq(1)
    expect(Database.connection.exec('SELECT * FROM tests').count).to eq(13)
  end
end
