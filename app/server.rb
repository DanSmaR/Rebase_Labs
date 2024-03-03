require 'rack/handler/puma'
require 'sinatra'
require 'csv'
require 'pg'

get '/tests' do
  content_type :json

end

conn = PG.connect(
  host: 'db',
  port: 5432,
  dbname: 'postgres',
  user: 'postgres',
  password: 'password'
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
