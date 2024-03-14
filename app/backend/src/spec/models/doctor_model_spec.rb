require_relative '../spec_helper'
require_relative '../../database/db_manager'
require_relative '../../models/doctor_model'

describe DoctorModel do
  let(:mock_conn) { double('PG::Connection') }
  let(:test_data) { ['doctor_crm', 'doctor_state', 'doctor_name', 'doctor_email'] }

  before do
    allow(DBManager).to receive(:conn).and_return(mock_conn)
    allow(mock_conn).to receive(:prepare)
    allow(mock_conn).to receive(:exec_prepared)
  end

  it '.prepare_data' do
    csv_row_data = {
      'crm médico' => 'doctor_crm',
      'crm médico estado' => 'doctor_state',
      'nome médico' => 'doctor_name',
      'email médico' => 'doctor_email'
    }

    expect(DoctorModel.prepare_data(csv_row_data)).to eq(test_data)
  end

  it '.prepare_insert' do
    INSERT_DOCTOR_STATEMENT = <<~SQL.gsub("\n", " ")
      INSERT INTO doctors (crm, crm_state, doctor_name, doctor_email)
      VALUES ($1, $2, $3, $4)
      ON CONFLICT (crm) DO NOTHING
    SQL
    expect(mock_conn).to receive(:prepare).with('insert_doctormodel', INSERT_DOCTOR_STATEMENT)

    DoctorModel.prepare_insert(mock_conn)
  end

  it '.exec_insert' do
    csv_row_data = {
      'crm médico' => 'doctor_crm',
      'crm médico estado' => 'doctor_state',
      'nome médico' => 'doctor_name',
      'email médico' => 'doctor_email'
    }

    expect(mock_conn).to receive(:exec_prepared).with('insert_doctormodel', test_data)

    DoctorModel.exec_insert(mock_conn, csv_row_data)
  end
end
