require_relative '../spec_helper'
require_relative '../../database/db_manager'
require_relative '../../models/test_model'

describe TestModel do
  let(:mock_conn) { double('PG::Connection') }
  let(:test_data) { ['exam_token', 'exam_type', 'exam_limits', 'exam_result'] }

  before do
    allow(DBManager).to receive(:conn).and_return(mock_conn)
    allow(mock_conn).to receive(:prepare)
    allow(mock_conn).to receive(:exec_prepared)
  end

  it '.prepare_data' do
    csv_row_data = {
      'token resultado exame' => 'exam_token',
      'tipo exame' => 'exam_type',
      'limites tipo exame' => 'exam_limits',
      'resultado tipo exame' => 'exam_result'
    }

    expect(TestModel.prepare_data(csv_row_data)).to eq(test_data)
  end

  it '.prepare_insert' do
    INSERT_TEST_STATEMENT = <<~SQL.gsub("\n", " ")
      INSERT INTO tests (exam_token, exam_type, exam_limits, exam_result)
      VALUES ($1, $2, $3, $4)
      ON CONFLICT (exam_token, exam_type) DO NOTHING
    SQL
    expect(mock_conn).to receive(:prepare).with('insert_testmodel', INSERT_TEST_STATEMENT)

    TestModel.prepare_insert(mock_conn)
  end

  it '.exec_insert' do
    csv_row_data = {
      'token resultado exame' => 'exam_token',
      'tipo exame' => 'exam_type',
      'limites tipo exame' => 'exam_limits',
      'resultado tipo exame' => 'exam_result'
    }

    expect(mock_conn).to receive(:exec_prepared).with('insert_testmodel', test_data)

    TestModel.exec_insert(mock_conn, csv_row_data)
  end
end
