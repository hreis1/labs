require './lib/database'

class Patient
  def self.create(cpf:, name:, email:, birthdate:, address:, city:, state:)
    if cpf.empty? || name.empty? || email.empty? || birthdate.empty? || address.empty? || city.empty? || state.empty?
      return
    end

    sql = <<~SQL
      INSERT INTO patients (cpf, name, email, birthdate, address, city, state)
      VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *
    SQL
    Database.connection.exec_params(sql, [cpf, name, email, birthdate, address, city, state]).entries.first
  end

  def self.find_by_cpf(cpf:)
    sql = 'SELECT * FROM patients WHERE cpf = $1 LIMIT 1'
    Database.connection.exec_params(sql, [cpf]).entries.first
  end
end
