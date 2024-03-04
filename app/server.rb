require 'rack/handler/puma'
require 'sinatra'
require_relative '../database/db_manager.rb'

get '/tests' do
  content_type :json

  result = DBManager.conn.exec(
    "
      SELECT p.*, d.*, e.*
      FROM exams e
      JOIN patients p ON p.cpf = e.patient_cpf
      JOIN doctors d ON d.crm = e.doctor_crm
    "
  )

  json = result.map { |row| row }.to_json
  json
end

unless ENV['RACK_ENV'] == 'test'
  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 3000,
    Host: '0.0.0.0'
  )
end
