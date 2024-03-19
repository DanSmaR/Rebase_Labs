require 'json'
require 'pg'
require_relative '../spec_helper.rb'
require_relative '../support/test_data.rb'

RSpec.describe 'Server' do
  describe 'GET /tests?page=2&limit=2' do
    let(:mock_conn) { instance_double(PG::Connection) }
    let(:test_query) {
      <<~SQL.gsub("\n", " ")
      SELECT p.*, d.*, e.*, t.*
      SELECT (SELECT * FROM exams LIMIT $1 OFFSET $2) e
      JOIN patients p ON p.cpf = e.patient_cpf
      JOIN doctors d ON d.crm = e.doctor_crm
      JOIN tests t ON t.exam_token = e.token
      SQL
    }

    before do
      allow(DBManager).to receive(:conn).and_return(mock_conn)
    end
    it 'returns the next 2 exams from database skipping the first 2 ones' do
      mock_pg_result = instance_double(PG::Result)

      allow(ExamModel).to receive(:count).with(mock_conn).and_return(mock_pg_result)
      allow(mock_pg_result).to receive(:to_a).and_return([{ "count" => api_response['results'].length }])

      allow(ExamDataBuilder).to receive(:get_exams_from_db).with(token: "", limit: 2, offset: 2).and_return(db_result[4..])

      response = get '/tests?page=2&limit=2'

      data = JSON.parse(response.body)

      expect(data).to eq({
        "previous" => { "limit" => 2, "page" => 1 },
        "next" => nil,
        "results" => api_response['results'][2..]
      })
    end

    context "when the result is empty" do
      it 'returns a 404 status code and the result' do
        mock_pg_result = instance_double(PG::Result)

        allow(ExamModel).to receive(:count).with(mock_conn).and_return(mock_pg_result)
        allow(mock_pg_result).to receive(:to_a).and_return([{ "count" => 0 }])

        allow(ExamDataBuilder).to receive(:get_exams_from_db).with(token: "", limit: 2, offset: 2).and_return([])

        response = get '/tests?page=2&limit=2'

        data = JSON.parse(response.body)

        expect(response.status).to eq 404
        expect(data).to eq({
          "previous" => nil,
          "next" => nil,
          "results" => []
        })
      end
    end

    context "when occurs a server error" do
      it "returns status code 500 and an error message" do
        allow(ExamModel).to receive(:count).with(mock_conn).and_raise(PG::Error)

        response = get '/tests?page=2&limit=2'

        data = JSON.parse(last_response.body)

        expect(last_response.status).to eq 500
        expect(data).to eq({ "error"=> true,  "message"=> 'An error has occurred. Try again' })
      end
    end
  end
end
