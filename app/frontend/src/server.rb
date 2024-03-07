require 'rack/handler/puma'
require 'sinatra'

get '/' do
  content_type 'text/html'
  File.open('src/index.html')
end


unless ENV['RACK_ENV'] == 'test'
  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 3000,
    Host: '0.0.0.0'
  )
end
