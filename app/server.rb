require 'rack/handler/puma'
require 'sinatra'
require 'csv'

get '/tests' do
  content_type :json
  rows = CSV.read("data/data.csv", col_sep: ';')

  columns = rows.shift

  rows.map do |row|
    row.each_with_object({}).with_index do |(cell, hash), idx|
      column = columns[idx]
      hash[column] = cell
    end
  end.to_json
end

unless ENV['RACK_ENV'] == 'test'
  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 3000,
    Host: '0.0.0.0'
  )
end
