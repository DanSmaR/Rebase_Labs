require 'rack/handler/puma'
require 'sinatra'
require 'csv'

get '/tests' do
  rows = CSV.read("./data.csv", col_sep: ';')

  columns = rows.shift

  rows.map do |row|
    row.each_with_object({}).with_index do |(cell, hash), idx|
      column = columns[idx]
      hash[column] = cell
    end
  end.to_json
end
