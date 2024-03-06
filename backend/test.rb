require_relative 'database'

class Test
  def self.all
    sql_select_all = 'SELECT * FROM tests'
    Database.execute(sql_select_all).to_a
  end
end
