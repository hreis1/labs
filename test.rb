require_relative 'database'

class Test
  def self.all
    sql_select_all = 'SELECT * FROM tests'
    Database.execute(sql_select_all).to_a
  end

  def self.create(params)
    sql_insert = <<~SQL
      INSERT INTO tests (
          patient_cpf, patient_name, patient_email, patient_birthdate,
          patient_address, patient_city, patient_state, doctor_crm,
          doctor_crm_state, doctor_name, doctor_email, exam_token,
          exam_date, exam_type, exam_limits, exam_result
          )
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)
    SQL

    Database.execute(sql_insert, params)
  end
end