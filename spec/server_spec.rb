require 'rack/test'
require 'rspec'
require_relative '../server'

RSpec.describe 'Server' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it '/' do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('Hello world!')
  end
end
