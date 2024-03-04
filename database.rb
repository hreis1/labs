require 'pg'

class Database
  def self.connection
    PG.connect(host: ENV['DB_HOST'] || 'localhost', 
    dbname: ENV['DB_NAME'] || 'postgres',
    user: 'postgres',
    password: 'postgres')
  end

  def self.execute(sql, params=[])
    connection.exec_params(sql, params)
  end
end
