class Test
  def self.create(exam_id:, type:, limits:, result:, conn:)
    sql = <<~SQL
      INSERT INTO tests (exam_id, type, limits, result)
      VALUES ($1, $2, $3, $4)
    SQL
    conn.exec_params(sql, [exam_id, type, limits, result])
  end
end
