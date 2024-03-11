require 'rack/handler/puma'
require 'sinatra'
require 'faraday'
require 'json'

get '/' do
  erb :index
end

get '/data' do
  content_type :json

  conn = Faraday.new(url: 'http://backend:3001') do |builder|
    builder.response :raise_error
  end

  if params[:token]
    response = conn.get('tests', token: params[:token])
  else
    response = conn.get('tests')
  end

  response.body
end

unless ENV['RACK_ENV'] == 'test'
  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 3000,
    Host: '0.0.0.0'
  )
end
