require_relative './lib/import'

import_from_csv(csv: File.read('./data/data.csv'))
