require 'rack/handler/puma'
require 'sinatra'
require_relative './database/db_manager.rb'
require_relative './database/database_setup.rb'
require_relative './exam_data_builder.rb'

QUERY = <<~SQL.gsub("\n", " ")
  SELECT p.*, d.*, e.*
  FROM exams e
  JOIN patients p ON p.cpf = e.patient_cpf
  JOIN doctors d ON d.crm = e.doctor_crm
SQL

get '/tests' do
  content_type :json
  response.headers['Access-Control-Allow-Origin'] = '*'

  result = ExamDataBuilder.get_exams_from_db("#{QUERY};")

  response = result.group_by { |item| item['token'] }.map do |token, items|
    ExamDataBuilder.build_exam_data(items)
  end

  response.to_json
end

get '/tests/:token' do
  content_type :json

  token = params['token']

  params = []

  if token && !token.empty?
    params << token
  end

  result = ExamDataBuilder.get_exams_from_db("#{QUERY} WHERE e.token = $1;", *params)

  response = result.group_by { |item| item['token'] }.map do |token, items|
    ExamDataBuilder.build_exam_data(items)
  end

  response.to_json
end

post '/import' do
  content_type :json

  begin
    if params[:file] && (tempfile = params[:file][:tempfile])
      DatabaseSetup.prepare_statements
      DatabaseSetup.insert_csv_data(tempfile.path)

      status 200
      { message: 'Data imported successfully' }.to_json
    else
      status 400
      { message: 'No file was uploaded' }.to_json
    end
  rescue => e
    status 500
    { message: 'An error occurred while importing data. Try again' }.to_json
  end
end

unless ENV['RACK_ENV'] == 'test'
  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 3001,
    Host: '0.0.0.0'
  )
end
