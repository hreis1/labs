require_relative '../app'
require_relative '../database'
require_relative '../lib/import'
require_relative '../models/doctor'
require_relative '../models/exam'
require_relative '../models/patient'
require_relative '../models/test'
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

  config.after(:all) do
    <<~SQL
      TRUNCATE TABLE patients, doctors, exams, tests
      RESTART IDENTITY
    SQL
  end
end
