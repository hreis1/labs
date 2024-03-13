require './lib/database'

class Exam
  def self.create(patient_id:, doctor_id:, result_token:, result_date:)
    return if patient_id.nil? || doctor_id.nil? || result_token.empty? || result_date.empty?
    sql = <<~SQL
      INSERT INTO exams (patient_id, doctor_id, result_token, result_date)
      VALUES ($1, $2, $3, $4) RETURNING *
    SQL
    begin
      Database.connection.exec_params(sql, [patient_id, doctor_id, result_token, result_date]).entries.first
    rescue PG::ForeignKeyViolation, PG::UniqueViolation
      nil
    end
  end

  def self.find_by_result_token(result_token:)
    sql = 'SELECT * FROM exams WHERE result_token = $1 LIMIT 1'
    exam = Database.connection.exec_params(sql, [result_token]).entries.first
    return nil if exam.nil?

    sql_complement = <<~SQL
      SELECT
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
      WHERE exams.id = $1
    SQL
    result = Database.connection.exec_params(sql_complement, [exam['id']]).entries
    {
      'id' => exam['id'],
      'result_token' => exam['result_token'],
      'result_date' => exam['result_date'],
      'cpf' => result[0]['cpf'],
      'patient_name' => result[0]['patient_name'],
      'email' => result[0]['email'],
      'birthdate' => result[0]['birthdate'],
      'doctor' => {
        'crm' => result[0]['crm'],
        'crm_state' => result[0]['crm_state'],
        'name' => result[0]['doctor_name']
      },
      'tests' => result.map do |test|
                   { 'type' => test['type'], 'limits' => test['limits'], 'result' => test['result'] }
                 end
    }
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
