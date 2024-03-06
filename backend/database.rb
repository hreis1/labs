require 'pg'

class Database
  def self.execute(sql, params = [])
    conn = PG.connect(host: 'postgres', dbname: 'postgres', user: 'postgres', password: 'postgres')
    conn.exec_params(sql, params)
  end
end
