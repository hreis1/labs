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
end
