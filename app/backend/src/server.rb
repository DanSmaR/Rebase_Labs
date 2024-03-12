require 'rack/handler/puma'
require 'sinatra'
require_relative './database/db_manager.rb'

def get_exams_from_db(query, *params)
  result = DBManager.conn.exec_params(query, params)
  result.map { |row| row }
end

def build_exam_tests(items)
  items.map do |item|
    {
      'type' => item['exam_type'],
      'limits' => item['exam_limits'],
      'result' => item['exam_result']
    }
  end
end

def build_doctor_data(items)
  {
    'crm' => items.first['crm'],
    'crm_state' => items.first['crm_state'],
    'name' => items.first['doctor_name'],
    'email' => items.first['doctor_email']
  }
end

def build_exam_data(items)
  {
    'token' => items.first['token'],
    'exam_date' => items.first['exam_date'],
    'cpf' => items.first['cpf'],
    'name' => items.first['patient_name'],
    'email' => items.first['patient_email'],
    'birthday' => items.first['birth_date'],
    'address' => items.first['address'],
    'city' => items.first['city'],
    'state' => items.first['state'],
    'doctor' => build_doctor_data(items),
    'tests' => build_exam_tests(items)
  }
end

QUERY = <<~SQL.gsub("\n", " ")
  SELECT p.*, d.*, e.*
  FROM exams e
  JOIN patients p ON p.cpf = e.patient_cpf
  JOIN doctors d ON d.crm = e.doctor_crm
SQL

get '/tests' do
  content_type :json

  result = get_exams_from_db("#{QUERY};")

  response = result.group_by { |item| item['token'] }.map do |token, items|
    build_exam_data(items)
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

  result = get_exams_from_db("#{QUERY} WHERE e.token = $1;", *params)

  response = result.group_by { |item| item['token'] }.map do |token, items|
    build_exam_data(items)
  end

  response.to_json
end

unless ENV['RACK_ENV'] == 'test'
  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 3001,
    Host: '0.0.0.0'
  )
end
