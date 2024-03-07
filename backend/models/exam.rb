class Exam
  def self.find_by_result_token(result_token:, result_date:, conn:)
    sql = 'SELECT id FROM exams WHERE result_token = $1 AND result_date = $2'
    conn.exec_params(sql, [result_token, result_date])
  end

  def self.create(patient_id:, doctor_id:, result_token:, result_date:, conn:)
    sql = <<~SQL
      INSERT INTO exams (patient_id, doctor_id, result_token, result_date)
      VALUES ($1, $2, $3, $4) RETURNING id
    SQL
    conn.exec_params(sql, [patient_id, doctor_id, result_token, result_date])
  end

  def self.all
    require 'pg'
    conn = PG.connect(dbname: 'postgres', user: 'postgres', password: 'postgres', host: 'postgres')

    sql = <<~SQL
      SELECT
        result_token,
        result_date,
        patients.cpf,
        patients.name AS patient_name,
        patients.email,
        patients.birthdate,
        doctors.crm,
        doctors.crm_state,
        doctors.name AS doctor_name,
        tests.type,
        tests.limits,
        tests.result
      FROM exams
      JOIN patients ON patient_id = patients.id
      JOIN doctors ON doctor_id = doctors.id
      JOIN tests ON exam_id = exams.id
    SQL

    result = conn.exec(sql).entries

    result.group_by { |exam| exam['result_token'] }.map do |result_token, tests|
      {
        result_token:,
        result_date: tests.first['result_date'],
        cpf: tests.first['cpf'],
        patient_name: tests.first['patient_name'],
        email: tests.first['email'],
        birthdate: tests.first['birthdate'],
        doctor: {
          crm: tests.first['crm'],
          crm_state: tests.first['crm_state'],
          name: tests.first['doctor_name']
        },
        tests: tests.map do |test|
          {
            type: test['type'],
            limits: test['limits'],
            result: test['result']
          }
        end
      }
    end
  end
end
