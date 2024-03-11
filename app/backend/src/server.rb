require 'rack/handler/puma'
require 'sinatra'
require_relative './database/db_manager.rb'

get '/tests' do
  content_type :json

  token = params[:token]

  query = <<~SQL.gsub("\n", " ")
    SELECT p.*, d.*, e.*
    FROM exams e
    JOIN patients p ON p.cpf = e.patient_cpf
    JOIN doctors d ON d.crm = e.doctor_crm
  SQL

  params = []

  if token && !token.empty?
    query += "\nWHERE e.token = $1"
    query.gsub("\n", " ")
    params << token
  end

  result = DBManager.conn.exec_params(query, params)

  json = result.map { |row| row }.to_json
  json
end

unless ENV['RACK_ENV'] == 'test'
  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 3001,
    Host: '0.0.0.0'
  )
end
