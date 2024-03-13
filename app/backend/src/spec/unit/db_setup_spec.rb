require_relative '../spec_helper.rb'
require_relative '../../database/db_manager.rb'
require_relative '../../database/database_setup'

describe DatabaseSetup do
  let(:mock_conn) { double('PG::Connection') }

  before do
    allow(DBManager).to receive(:conn).and_return(mock_conn)
  end

  describe '.prepare_statements' do
    it 'prepares the statements successfully' do
      INSERT_PATIENTS_STATEMENT = <<~SQL.gsub("\n", " ")
        INSERT INTO patients (cpf, patient_name, patient_email, birth_date, address, city, state)
        VALUES ($1, $2, $3, $4, $5, $6, $7)
        ON CONFLICT (cpf) DO NOTHING
      SQL
      INSERT_DOCTORS_STATEMENT = <<~SQL.gsub("\n", " ")
        INSERT INTO doctors (crm, crm_state, doctor_name, doctor_email)
        VALUES ($1, $2, $3, $4)
        ON CONFLICT (crm) DO NOTHING
      SQL
      INSERT_EXAMS_STATEMENT = <<~SQL.gsub("\n", " ")
        INSERT INTO exams (patient_cpf, doctor_crm, token, exam_date, exam_type, exam_limits, exam_result)
        VALUES ($1, $2, $3, $4, $5, $6, $7)
      SQL

      expect(mock_conn).to receive(:prepare).with("insert_patient", INSERT_PATIENTS_STATEMENT).and_return(nil)
      expect(mock_conn).to receive(:prepare).with("insert_doctor", INSERT_DOCTORS_STATEMENT).and_return(nil)
      expect(mock_conn).to receive(:prepare).with("insert_exam", INSERT_EXAMS_STATEMENT).and_return(nil)

      DatabaseSetup.prepare_statements
    end
  end

  describe '.insert_csv_data' do
    it 'inserts data from csv successfully' do
      PATH_FILE = 'src/data/data.csv'

      allow(CSV).to receive(:foreach).with(PATH_FILE, headers: true, col_sep: ';').and_yield({
        'cpf' => '123',
        'nome paciente' => 'John Doe',
        'email paciente' => 'mariana_crist@kutch-torp.com',
        'data nascimento paciente' => '1995-07-03',
        'endereço/rua paciente' => '527 Rodovia Júlio',
        'cidade paciente' => 'Lagoa da Canoa',
        'estado patiente' => 'Paraíba',
        'crm médico' => 'B0002IQM66',
        'crm médico estado' => 'SC',
        'nome médico' => 'Maria Helena Ramalho',
        'email médico' => 'rayford@kemmer-kunze.info',
        'token resultado exame' => '0W9I67',
        'data exame' => '2021-07-09',
        'tipo exame' => 'hemácias',
        'limites tipo exame' => '45-52',
        'resultado tipo exame' => '28'
      })
      expect(mock_conn).to receive(:transaction).and_yield
      expect(mock_conn).to receive(:exec_prepared).with("insert_patient", [
        '123',
        'John Doe',
        'mariana_crist@kutch-torp.com',
        '1995-07-03',
        '527 Rodovia Júlio',
        'Lagoa da Canoa',
        'Paraíba'
      ]).and_return(nil)
      expect(mock_conn).to receive(:exec_prepared).with("insert_doctor", [
        'B0002IQM66',
        'SC',
        'Maria Helena Ramalho',
        'rayford@kemmer-kunze.info',
      ]).and_return(nil)
      expect(mock_conn).to receive(:exec_prepared).with("insert_exam", [
        '123',
        'B0002IQM66',
        '0W9I67',
        '2021-07-09',
        'hemácias',
        '45-52',
        '28'
      ]).and_return(nil)

      DatabaseSetup.insert_csv_data(PATH_FILE)
    end
  end
end
