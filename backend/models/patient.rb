class Patient
  def self.create(cpf:, name:, email:, birthdate:, address:, city:, state:, conn:)
    sql = <<~SQL
      INSERT INTO patients (cpf, name, email, birthdate, address, city, state)
      VALUES ($1, $2, $3, $4, $5, $6, $7)
      RETURNING id
    SQL
    conn.exec_params(sql, [cpf, name, email, birthdate, address, city, state])
  end

  def self.find_by_cpf(cpf:, conn:)
    sql = 'SELECT id FROM patients WHERE cpf = $1'
    conn.exec_params(sql, [cpf])
  end
end
