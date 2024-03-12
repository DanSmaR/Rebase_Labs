require_relative './db_manager.rb'
require 'csv'

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
