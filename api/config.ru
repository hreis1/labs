require './app'
require 'rack/handler/puma'

Rackup::Handler::Puma.run Sinatra::Application, Port: 3000
