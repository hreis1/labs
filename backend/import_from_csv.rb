require 'csv'
require 'pg'
require_relative './models/patient'
require_relative './models/doctor'
require_relative './models/exam'
require_relative './models/test'

rows = CSV.read('./data/data.csv', col_sep: ';')
rows.shift

connection = PG.connect(dbname: 'postgres', user: 'postgres', password: 'postgres', host: 'postgres')

connection.transaction do |conn|
  rows.each do |row|
    cpf, name, email, birthdate, address, city, state = row[0..6]

    patient = Patient.find_by_cpf(cpf:, conn:)
    patient = Patient.create(cpf:, name:, email:, birthdate:, address:, city:, state:, conn:) if patient.none?
    patient_id = patient.first['id']

    crm, crm_state, name, email = row[7..10]
    doctor = Doctor.find_by_crm(crm:, crm_state:, conn:)
    doctor = Doctor.create(crm:, crm_state:, name:, email:, conn:) if doctor.none?
    doctor_id = doctor.first['id']

    result_token, result_date = row[11..12]
    exam = Exam.find_by_result_token(result_token:, result_date:, conn:)
    exam = Exam.create(patient_id:, doctor_id:, result_token:, result_date:, conn:) if exam.none?
    exam_id = exam.first['id']

    type, limits, result = row[13..15]
    Test.create(exam_id:, type:, limits:, result:, conn:)
  end
end
