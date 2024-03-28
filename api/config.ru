require './app'
require 'rack/handler/puma'
require 'sidekiq/web'
require 'securerandom'

File.open('.session.key', 'w') { |f| f.write(SecureRandom.hex(32)) }

app = Rack::Builder.new do
  use Rack::Session::Cookie, secret: File.read('.session.key'), same_site: true, max_age: 86_400
  run Rack::URLMap.new('/' => Sinatra::Application, '/sidekiq' => Sidekiq::Web)
end

Rackup::Handler::Puma.run app, Port: 3000
