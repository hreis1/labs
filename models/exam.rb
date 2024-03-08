require_relative '../database'

class Exam
  def self.create(patient_id:, doctor_id:, result_token:, result_date:)
    sql = <<~SQL
      INSERT INTO exams (patient_id, doctor_id, result_token, result_date)
      VALUES ($1, $2, $3, $4) RETURNING *
    SQL
    Database.connection.exec_params(sql, [patient_id, doctor_id, result_token, result_date]).entries.first
  end

  def self.find_by_result_token(result_token:)
    sql = 'SELECT * FROM exams WHERE result_token = $1 LIMIT 1'
    Database.connection.exec_params(sql, [result_token]).entries.first
  end

  def self.all
    sql = <<~SQL
      SELECT
        result_token, result_date,
        patients.cpf,
        patients.name AS patient_name,
        patients.email,
        patients.birthdate,
        doctors.crm,
        doctors.crm_state,
        doctors.name AS doctor_name,
        tests.type, tests.limits, tests.result
      FROM exams
      JOIN patients ON patient_id = patients.id
      JOIN doctors  ON doctor_id = doctors.id
      JOIN tests    ON exam_id = exams.id
    SQL

    result = Database.connection.exec(sql).entries
    exams = {}
    result.each do |test|
      if exams[test['result_token']]
        exams[test['result_token']]['tests'] << { 'type' => test['type'], 'limits' => test['limits'],
                                                  'result' => test['result'] }
      else
        exams[test['result_token']] = {
          'result_token' => test['result_token'],
          'result_date' => test['result_date'],
          'cpf' => test['cpf'],
          'patient_name' => test['patient_name'],
          'email' => test['email'],
          'birthdate' => test['birthdate'],
          'doctor' => {
            'crm' => test['crm'],
            'crm_state' => test['crm_state'],
            'name' => test['doctor_name']
          },
          'tests' => [{ 'type' => test['type'], 'limits' => test['limits'], 'result' => test['result'] }]
        }
      end
    end
    exams.values
  end
end

# {
#   result_token:,
#   result_date: tests.first['result_date'],
#   cpf: tests.first['cpf'],
#   patient_name: tests.first['patient_name'],
#   email: tests.first['email'],
#   birthdate: tests.first['birthdate'],
#   doctor: {
#     crm: tests.first['crm'],
#     crm_state: tests.first['crm_state'],
#     name: tests.first['doctor_name']
#   },
#   tests: tests.map do |test|
#     {
#       type: test['type'],
#       limits: test['limits'],
#       result: test['result']
#     }
#   end
# }
