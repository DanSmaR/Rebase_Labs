require_relative '../spec_helper.rb'
require_relative '../../exam_data_builder.rb'
require_relative '../support/test_data.rb'

RSpec.describe ExamDataBuilder do
  let(:items) do
    [
      {
        'token' => 'IQCZ17',
        'exam_date' => '2021-08-05',
        'cpf' => '048.973.170-88',
        'patient_name' => 'Maria Luiza Pires',
        'patient_email' => 'denna@wisozk.biz',
        'birth_date' => '2001-03-11',
        'address' => '165 Rua Rafaela',
        'city' => 'Ituverava',
        'state' => 'Alagoas',
        'crm' => 'B000BJ20J4',
        'crm_state' => 'PI',
        'doctor_name' => 'Dr. Rafael',
        'doctor_email' => 'dr.rafael@example.com',
        'exam_type' => 'hemácias',
        'exam_limits' => '45-52',
        'exam_result' => '97'
      }
    ]
  end

  describe '.build_exam_data' do
    it 'builds exam data from items' do
      result = ExamDataBuilder.build_exam_data(items)
      expect(result).to be_a(Hash)
      expect(result['token']).to eq('IQCZ17')
      expect(result['exam_date']).to eq('2021-08-05')
      expect(result['cpf']).to eq('048.973.170-88')
      expect(result['name']).to eq('Maria Luiza Pires')
      expect(result['email']).to eq('denna@wisozk.biz')
      expect(result['birthday']).to eq('2001-03-11')
      expect(result['address']).to eq('165 Rua Rafaela')
      expect(result['city']).to eq('Ituverava')
      expect(result['state']).to eq('Alagoas')
      expect(result['doctor']).to be_a(Hash)
      expect(result['tests']).to be_a(Array)
    end
  end

  describe '.build_doctor_data' do
    it 'builds doctor data from items' do
      result = ExamDataBuilder.build_doctor_data(items)
      expect(result).to be_a(Hash)
      expect(result['crm']).to eq('B000BJ20J4')
      expect(result['crm_state']).to eq('PI')
      expect(result['name']).to eq('Dr. Rafael')
      expect(result['email']).to eq('dr.rafael@example.com')
    end
  end

  describe '.build_exam_tests' do
    it 'builds exam tests from items' do
      result = ExamDataBuilder.build_exam_tests(items)
      expect(result).to be_a(Array)
      expect(result.first['type']).to eq('hemácias')
      expect(result.first['limits']).to eq('45-52')
      expect(result.first['result']).to eq('97')
    end
  end

  describe '.get_exams_from_db' do
    let(:query) {
      [
        'SELECT p.*, d.*, e.*, t.* ',
        'FROM exams e ',
        'FROM (SELECT * FROM exams LIMIT $1 OFFSET $2) e ',
        'JOIN patients p ON p.cpf = e.patient_cpf JOIN doctors d ON d.crm = e.doctor_crm ',
        'JOIN tests t ON t.exam_token = e.token'
      ]
    }
    let(:mock_conn) { instance_double(PG::Connection) }

    before do
      allow(DBManager).to receive(:conn).and_return(mock_conn)
    end
    it 'returns all exams data from DB' do
      final_query = "#{query[0] + query[1] + query[3] + query[4]} ORDER BY e.exam_date DESC, t.exam_type;"

      allow(mock_conn).to receive(:exec_params).with(final_query, []).and_return(db_result)

      results = ExamDataBuilder.get_exams_from_db

      expect(results).to eq db_result
    end

    it "returns one exam by token" do
      final_query = "#{query[0] + query[1] + query[3] + query[4] } WHERE e.token = $1;"
      token = '0W9I67'

      allow(mock_conn).to receive(:exec_params).with(final_query, [token]).and_return(db_result[2..3])

      results = ExamDataBuilder.get_exams_from_db(token:)

      expect(results).to eq db_result[2..3]
    end

    it 'returns a slice of exams when given an offset and limit as arguments' do
      final_query = "#{query[0] + query[2] + query[3] + query[4]} ORDER BY e.exam_date DESC, t.exam_type;"
      limit = 2
      offset = 2
      params = [limit, offset]

      allow(mock_conn).to receive(:exec_params).with(final_query, params).and_return(db_result[4..])

      results = ExamDataBuilder.get_exams_from_db(limit:, offset:)

      expect(results).to eq db_result[4..]
    end

    it 'raises a DatabaseError when a PG::Error is raised' do
      allow(mock_conn).to receive(:exec_params).and_raise(PG::Error.new('An error occurred'))

      expect { ExamDataBuilder.get_exams_from_db }.to raise_error(DataBaseError, 'An error occurred')
    end
  end
end
