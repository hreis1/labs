require 'csv'
require 'pg'

rows = CSV.read('./data.csv', col_sep: ';')

columns = rows.shift

rows.map do |row|
  row.each_with_object({}).with_index do |(cell, acc), idx|
    column = columns[idx]
    acc[column] = cell
  end
end

conn = PG.connect(
  host: ENV['DB_HOST'] || 'localhost',
  password: 'postgres',
  user: 'postgres',
  dbname: 'postgres'
)

sql_insert = <<~SQL
  INSERT INTO tests (
      patient_cpf, patient_name, patient_email, patient_birthdate,
      patient_address, patient_city, patient_state, doctor_crm,
      doctor_crm_state, doctor_name, doctor_email, exam_token,
      exam_date, exam_type, exam_limits, exam_result
      )
    VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)
SQL

rows.each_with_index do |row, idx|
  print "Importing data... #{idx + 1}/#{rows.size}\r"
  conn.exec(sql_insert, row)
  system('clear')
end
