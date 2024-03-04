require 'csv'
require_relative 'test'

rows = CSV.read('./data.csv', col_sep: ';')

columns = rows.shift

rows.map do |row|
  row.each_with_object({}).with_index do |(cell, acc), idx|
    column = columns[idx]
    acc[column] = cell
  end
end

rows.each_with_index do |row, idx|
  print "Importing data... #{idx + 1}/#{rows.size}\r"
  Test.create(row)
  system('clear')
end
