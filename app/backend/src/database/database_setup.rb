require_relative './db_manager.rb'
require 'csv'

puts 'Creating the tables ...'

DBManager.conn.exec("
  CREATE TABLE IF NOT EXISTS patients (
    cpf VARCHAR PRIMARY KEY,
    name VARCHAR,
    email VARCHAR,
    birth_date DATE,
    address VARCHAR,
    city VARCHAR,
    state VARCHAR
  )
")

DBManager.conn.exec("
  CREATE TABLE IF NOT EXISTS doctors (
    crm VARCHAR PRIMARY KEY,
    crm_state VARCHAR,
    name VARCHAR,
    email VARCHAR
  )
")

DBManager.conn.exec("
  CREATE TABLE IF NOT EXISTS exams (
    id SERIAL PRIMARY KEY,
    patient_cpf VARCHAR REFERENCES patients(cpf),
    doctor_crm VARCHAR REFERENCES doctors(crm),
    token VARCHAR,
    exam_date DATE,
    exam_type VARCHAR,
    exam_limits VARCHAR,
    exam_result VARCHAR
  )
")

puts 'Populating the tables with data...'

CSV.foreach('src/data/data.csv', headers: true, col_sep: ';') do |row|
  insert_patient_statement = DBManager.conn.prepare("
    INSERT INTO patients (cpf, name, email, birth_date, address, city, state)
    VALUES ($1, $2, $3, $4, $5, $6, $7)
    ON CONFLICT (cpf) DO NOTHING
  ")

  insert_doctor_statement = DBManager.conn.prepare("
    INSERT INTO doctors (crm, crm_state, name, email)
    VALUES ($1, $2, $3, $4)
    ON CONFLICT (crm) DO NOTHING
  ")

  insert_exam_statement = DBManager.conn.prepare("
    INSERT INTO exams (patient_cpf, doctor_crm, token, exam_date, exam_type, exam_limits, exam_result)
    VALUES ($1, $2, $3, $4, $5, $6, $7)
  ")

  insert_patient_statement.execute(
    row['cpf'],
    row['nome paciente'],
    row['email paciente'],
    row['data nascimento paciente'],
    row['endereço/rua paciente'],
    row['cidade paciente'],
    row['estado patiente']
  )

  insert_doctor_statement.execute(
    row['crm médico'],
    row['crm médico estado'],
    row['nome médico'],
    row['email médico']
  )

  insert_exam_statement.execute(
    row['cpf'],
    row['crm médico'],
    row['token resultado exame'],
    row['data exame'],
    row['tipo exame'],
    row['limites tipo exame'],
    row['resultado tipo exame']
  )
end

puts 'Done'
