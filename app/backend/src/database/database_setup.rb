require_relative './db_manager.rb'
require 'csv'

puts 'Creating the tables ...'

DBManager.conn.exec("
  CREATE TABLE IF NOT EXISTS patients (
    cpf VARCHAR PRIMARY KEY,
    patient_name VARCHAR,
    patient_email VARCHAR,
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
    doctor_name VARCHAR,
    doctor_email VARCHAR
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

DBManager.conn.prepare("insert_patient", "
  INSERT INTO patients (cpf, patient_name, patient_email, birth_date, address, city, state)
  VALUES ($1, $2, $3, $4, $5, $6, $7)
  ON CONFLICT (cpf) DO NOTHING
")

DBManager.conn.prepare("insert_doctor", "
  INSERT INTO doctors (crm, crm_state, doctor_name, doctor_email)
  VALUES ($1, $2, $3, $4)
  ON CONFLICT (crm) DO NOTHING
")

DBManager.conn.prepare("insert_exam", "
  INSERT INTO exams (patient_cpf, doctor_crm, token, exam_date, exam_type, exam_limits, exam_result)
  VALUES ($1, $2, $3, $4, $5, $6, $7)
")

DBManager.conn.transaction do
  CSV.foreach('src/data/data.csv', headers: true, col_sep: ';') do |row|
    DBManager.conn.exec_prepared("insert_patient", [
        row['cpf'],
        row['nome paciente'],
        row['email paciente'],
        row['data nascimento paciente'],
        row['endereço/rua paciente'],
        row['cidade paciente'],
        row['estado patiente']
    ]);

    DBManager.conn.exec_prepared("insert_doctor", [
      row['crm médico'],
      row['crm médico estado'],
      row['nome médico'],
      row['email médico']
    ]);

    DBManager.conn.exec_prepared("insert_exam", [
      row['cpf'],
      row['crm médico'],
      row['token resultado exame'],
      row['data exame'],
      row['tipo exame'],
      row['limites tipo exame'],
      row['resultado tipo exame']
    ]);
  end
end

puts 'Done'
