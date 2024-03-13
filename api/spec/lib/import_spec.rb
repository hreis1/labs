require 'spec_helper'

RSpec.describe Import do
  describe '#import_from_csv' do
    it 'com sucesso' do
      csv = File.read('spec/support/data.csv')
      Import.import_from_csv(csv: csv)
      
      expect(Database.connection.exec('SELECT * FROM patients').count).to eq(1)
      expect(Database.connection.exec('SELECT * FROM doctors').count).to eq(1)
      expect(Database.connection.exec('SELECT * FROM exams').count).to eq(1)
      expect(Database.connection.exec('SELECT * FROM tests').count).to eq(13)
    end
  end

  describe '#valid?' do
    it 'com sucesso' do
      csv = File.read('spec/support/data.csv')
      expect(Import.valid?(csv: csv)).to eq(true)
    end

    it 'com falha' do
      csv = File.read('spec/support/invalid_data.csv')
      expect(Import.valid?(csv:)).to eq(false)
    end
  end
end
