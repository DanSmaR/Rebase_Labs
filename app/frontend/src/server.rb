require 'rack/handler/puma'
require 'sinatra'
require 'faraday'
require 'json'

get '/' do
  erb :index
end

unless ENV['RACK_ENV'] == 'test'
  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 3000,
    Host: '0.0.0.0'
  )
end
