require './lib/database'

class Test
  def self.create(exam_id:, type:, limits:, result:)
    return if exam_id.nil? || type.empty? || limits.empty? || result.nil?
    sql = <<~SQL
      INSERT INTO tests (exam_id, type, limits, result)
      VALUES ($1, $2, $3, $4) RETURNING *
    SQL
    Database.connection.exec_params(sql, [exam_id, type, limits, result]).entries.first
  end
end
