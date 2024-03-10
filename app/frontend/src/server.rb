require 'rack/handler/puma'
require 'sinatra'
require 'faraday'

get '/' do
  erb :index
end

get '/data' do
  content_type :json
  conn = Faraday.new(
    url: 'http://localhost:3001',
    headers: {'Accept' => 'application/json'}
  )
  response = conn.get('/tests')
end


unless ENV['RACK_ENV'] == 'test'
  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 3000,
    Host: '0.0.0.0'
  )
end
