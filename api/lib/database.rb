require 'pg'

ENV['DB_NAME'] = 'postgres_test' if ENV['APP_ENV'] == 'test'

class Database
  def self.connection
    @connection ||= PG.connect(dbname: ENV['DB_NAME'] || 'postgres',
                               user: ENV['DB_USER'] || 'postgres',
                               password: ENV['DB_PASSWORD'] || 'postgres',
                               host: ENV['DB_HOST'] || 'postgres')
  end
end
