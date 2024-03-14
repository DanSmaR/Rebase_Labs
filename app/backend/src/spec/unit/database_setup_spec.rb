require_relative '../spec_helper.rb'
require_relative '../../database/database_setup.rb'
require_relative '../../database/db_manager.rb'
require_relative '../../models/patient_model.rb'
require_relative '../../models/doctor_model.rb'
require_relative '../../models/exam_model.rb'
require_relative '../../models/test_model.rb'

describe DatabaseSetup do
  let(:mock_conn) { double('PG::Connection') }
  let(:test_file_path) { 'src/data/data.csv' }

  before do
    allow(DBManager).to receive(:conn).and_return(mock_conn)
  end

  it 'prepares the statements successfully' do
    MODELS = [PatientModel, DoctorModel, ExamModel, TestModel]

    MODELS.each do |model|
      expect(model).to receive(:prepare_insert).with(mock_conn)
    end

    DatabaseSetup.prepare_statements(mock_conn)
  end

  it 'inserts data from csv successfully' do
    csv_data = [
      {
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
      }
    ]

    expect(mock_conn).to receive(:transaction).and_yield
    MODELS.each do |model|
      expect(model).to receive(:exec_insert).with(mock_conn, csv_data[0])
    end

    allow(CSV).to receive(:foreach).with(test_file_path, headers: true, col_sep: ';').and_yield(csv_data[0])

    DatabaseSetup.insert_csv_data(test_file_path, mock_conn)
  end

  it '.seed' do
    expect(DatabaseSetup).to receive(:prepare_statements).with(mock_conn)
    expect(DatabaseSetup).to receive(:insert_csv_data).with(test_file_path, mock_conn)

    DatabaseSetup.seed(mock_conn)
  end
end
