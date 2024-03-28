require 'spec_helper'

RSpec.describe ImportJob do
  describe '#perform' do
    it 'e popula o banco de dados com os dados do CSV' do
      csv = File.read('spec/support/data.csv')
      ImportJob.perform_sync(csv)

      expect(Database.connection.exec('SELECT * FROM exams').count).to eq(1)
      expect(Database.connection.exec('SELECT * FROM patients').count).to eq(1)
      expect(Database.connection.exec('SELECT * FROM doctors').count).to eq(1)
      expect(Database.connection.exec('SELECT * FROM tests').count).to eq(13)
    end
  end
end
