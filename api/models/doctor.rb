require './lib/database'

class Doctor
  def self.create(crm:, crm_state:, name:, email:)
    sql = <<~SQL
      INSERT INTO doctors (crm, crm_state, name, email)
      VALUES ($1, $2, $3, $4)
      RETURNING *
    SQL
    Database.connection.exec_params(sql, [crm, crm_state, name, email]).entries.first
  end

  def self.find_by_crm(crm:, crm_state:)
    sql = 'SELECT * FROM doctors WHERE crm = $1 AND crm_state = $2 LIMIT 1'
    Database.connection.exec_params(sql, [crm, crm_state]).entries.first
  end
end
