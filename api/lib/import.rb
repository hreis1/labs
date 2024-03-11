require './models/patient'
require './models/doctor'
require './models/exam'
require './models/test'
require 'benchmark'
require 'csv'

def import_from_csv(csv:)
  rows = CSV.parse(csv, col_sep: ';')
  rows.shift
  @time = Benchmark.measure do
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
end
