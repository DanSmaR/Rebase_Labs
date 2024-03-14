require_relative '../spec_helper'
require_relative '../../database/db_manager'
require_relative '../../models/exam_model'

describe ExamModel do
  let(:mock_conn) { double('PG::Connection') }
  let(:test_data) { ['exam_token', 'patient_cpf', 'doctor_crm', 'exam_date'] }

  before do
    allow(DBManager).to receive(:conn).and_return(mock_conn)
    allow(mock_conn).to receive(:prepare)
    allow(mock_conn).to receive(:exec_prepared)
  end

  it '.prepare_data' do
    csv_row_data = {
      'token resultado exame' => 'exam_token',
      'cpf' => 'patient_cpf',
      'crm médico' => 'doctor_crm',
      'data exame' => 'exam_date'
    }

    expect(ExamModel.prepare_data(csv_row_data)).to eq(test_data)
  end

  it '.prepare_insert' do
    INSERT_EXAM_STATEMENT = <<~SQL.gsub("\n", " ")
      INSERT INTO exams (token, patient_cpf, doctor_crm, exam_date)
      VALUES ($1, $2, $3, $4)
      ON CONFLICT (token) DO NOTHING
    SQL
    expect(mock_conn).to receive(:prepare).with('insert_exammodel', INSERT_EXAM_STATEMENT)

    ExamModel.prepare_insert(mock_conn)
  end

  it '.exec_insert' do
    csv_row_data = {
      'token resultado exame' => 'exam_token',
      'cpf' => 'patient_cpf',
      'crm médico' => 'doctor_crm',
      'data exame' => 'exam_date'
    }

    expect(mock_conn).to receive(:exec_prepared).with('insert_exammodel', test_data)

    ExamModel.exec_insert(mock_conn, csv_row_data)
  end
end
