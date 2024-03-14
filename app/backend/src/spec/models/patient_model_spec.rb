require_relative '../spec_helper'
require_relative '../../database/db_manager'
require_relative '../../models/patient_model'

describe PatientModel do
  let(:mock_conn) { double('PG::Connection') }
  let(:test_data) { ['patient_cpf', 'patient_name', 'patient_email', 'birth_date', 'address', 'city', 'state'] }

  before do
    allow(DBManager).to receive(:conn).and_return(mock_conn)
    allow(mock_conn).to receive(:prepare)
    allow(mock_conn).to receive(:exec_prepared)
  end

  it '.prepare_data' do
    csv_row_data = {
      'cpf' => 'patient_cpf',
      'nome paciente' => 'patient_name',
      'email paciente' => 'patient_email',
      'data nascimento paciente' => 'birth_date',
      'endereço/rua paciente' => 'address',
      'cidade paciente' => 'city',
      'estado patiente' => 'state'
    }

    expect(PatientModel.prepare_data(csv_row_data)).to eq(test_data)
  end

  it '.prepare_insert' do
    INSERT_PATIENT_STATEMENT = <<~SQL.gsub("\n", " ")
      INSERT INTO patients (cpf, patient_name, patient_email, birth_date, address, city, state)
      VALUES ($1, $2, $3, $4, $5, $6, $7)
      ON CONFLICT (cpf) DO NOTHING
    SQL
    expect(mock_conn).to receive(:prepare).with('insert_patientmodel', INSERT_PATIENT_STATEMENT)

    PatientModel.prepare_insert(mock_conn)
  end

  it '.exec_insert' do
    csv_row_data = {
      'cpf' => 'patient_cpf',
      'nome paciente' => 'patient_name',
      'email paciente' => 'patient_email',
      'data nascimento paciente' => 'birth_date',
      'endereço/rua paciente' => 'address',
      'cidade paciente' => 'city',
      'estado patiente' => 'state'
    }

    expect(mock_conn).to receive(:exec_prepared).with('insert_patientmodel', test_data)

    PatientModel.exec_insert(mock_conn, csv_row_data)
  end
end
