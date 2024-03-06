class Doctor
  def self.create(crm:, crm_state:, name:, email:, conn:)
    sql = <<~SQL
      INSERT INTO doctors (crm, crm_state, name, email)
      VALUES ($1, $2, $3, $4)
      RETURNING id
    SQL
    conn.exec_params(sql, [crm, crm_state, name, email])
  end

  def self.find_by_crm(crm:, crm_state:, conn:)
    sql = 'SELECT id FROM doctors WHERE crm = $1 AND crm_state = $2'
    conn.exec_params(sql, [crm, crm_state])
  end
end