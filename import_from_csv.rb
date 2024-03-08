require 'csv'
require_relative './models/patient'
require_relative './models/doctor'
require_relative './models/exam'
require_relative './models/test'
require 'benchmark'

rows = CSV.read('./data/data.csv', col_sep: ';')
rows.shift
time = Benchmark.measure do
  Database.connection.transaction do |conn|
    @connection = conn
    rows.each do |row|
      cpf, name, email, birthdate, address, city, state = row[0..6]

      patient = Patient.find_by_cpf(cpf:)
      patient ||= Patient.create(cpf:, name:, email:, birthdate:, address:, city:, state:)

      crm, crm_state, name, email = row[7..10]
      doctor = Doctor.find_by_crm(crm:, crm_state:)
      doctor ||= Doctor.create(crm:, crm_state:, name:, email:)

      result_token, result_date = row[11..12]
      exam = Exam.find_by_result_token(result_token:)
      exam ||= Exam.create(patient_id: patient['id'], doctor_id: doctor['id'], result_token:, result_date:)

      type, limits, result = row[13..15]
      Test.create(exam_id: exam['id'], type:, limits:, result:)
    end
  end
end

puts "Imported in #{time.real} seconds"
