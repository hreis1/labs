require 'pg'

conn = PG.connect(
  host: ENV['DB_HOST'] || 'localhost',
  password: 'postgres',
  user: 'postgres',
  dbname: 'postgres'
)

class Test
  def self.all
    conn.exec('SELECT * FROM tests').to_a
  end
end