require 'rack/handler/puma'
require 'sinatra'
require 'csv'
require 'pg'
require 'uri'

get '/tests' do
  content_type :json
end

uri = URI.parse(ENV['DATABASE_URL'])

conn = PG.connect(
  host: uri.hostname,
  port: uri.port,
  dbname: uri.path[1..-1],
  user: uri.user,
  password: uri.password
)

CSV.foreach("data/data.csv", headers: true, col_sep: ';') do |row|
  puts '------'
  puts row.inspect
  puts '------'
end

unless ENV['RACK_ENV'] == 'test'
  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 3000,
    Host: '0.0.0.0'
  )
end
