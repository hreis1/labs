require './app'
require './database'
require './lib/import'
require './models/doctor'
require './models/exam'
require './models/patient'
require './models/test'
require 'rack/test'

def app
  Sinatra::Application
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.before(:each) do
    sql_truncate = <<~SQL
      TRUNCATE TABLE patients, doctors, exams, tests
      RESTART IDENTITY
    SQL
    Database.connection.exec(sql_truncate)
  end
end
