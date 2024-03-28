require './lib/import'

begin
  csv = File.read('./data/data.csv')
  raise 'Invalid file' unless Import.valid?(csv: csv)

  Import.import_from_csv(csv: File.read('./data/data.csv'))
rescue StandardError => e
  puts e.message
end
