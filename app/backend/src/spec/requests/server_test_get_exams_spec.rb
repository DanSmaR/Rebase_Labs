require 'json'
require 'pg'
require_relative '../spec_helper.rb'
require_relative '../support/test_data.rb'

RSpec.describe 'Server' do
  describe 'GET /tests' do
    let(:mock_conn) { instance_double(PG::Connection) }
    let(:test_query) {
      <<~SQL.gsub("\n", " ")
      SELECT p.*, d.*, e.*, t.*
      FROM exams e
      JOIN patients p ON p.cpf = e.patient_cpf
      JOIN doctors d ON d.crm = e.doctor_crm
      JOIN tests t ON t.exam_token = e.token
      SQL
    }

    before do
      allow(DBManager).to receive(:conn).and_return(mock_conn)
    end
    it 'returns the exams data' do
      allow(mock_conn).to receive(:exec_params).with("#{test_query}ORDER BY e.exam_date DESC;", []).and_return(db_result)

      response = get '/tests'

      data = JSON.parse(response.body)

      expect(data).to eq(api_response)
    end

    context "when the result is empty" do
      it 'returns a 404 status code and the result' do
        allow(mock_conn).to receive(:exec_params).with("#{test_query}ORDER BY e.exam_date DESC;", []).and_return([])

        response = get '/tests'

        data = JSON.parse(response.body)

        expect(response.status).to eq 404
        expect(data).to eq({
          "previous" => nil,
          "next" => nil,
          "results" => []
        })
      end
    end

    context 'with token params' do
      it 'returns the specific exams data' do
        token = 'IQCZ17'

        allow(mock_conn).to receive(:exec_params).with("#{test_query}WHERE e.token = $1;", [token]).and_return(db_result[0..1])

        response = get "/tests/#{token}"

        data = JSON.parse(response.body)

        expect(data).to eq([api_response['results'][0]])
      end
    end

    context "when token does not exist" do
      it "returns a 404 status code and and an empty array" do
        token = 'foo'

        allow(mock_conn).to receive(:exec_params).with("#{test_query}WHERE e.token = $1;", [token]).and_return([])

        response = get "/tests/#{token}"

        data =JSON.parse(response.body)

        expect(response.status).to eq 404
        expect(data).to eq []
      end
    end

    context "when occurs a server error" do
      it "returns status code 500 and an error message" do
        allow(mock_conn).to receive(:exec_params).and_raise(PG::Error)

        get "/tests/IQCZ17"

        data = JSON.parse(last_response.body)

        expect(last_response.status).to eq 500
        expect(data).to eq({ "error"=> true,  "message"=> 'An error has occurred. Try again' })
      end

    end


  end
end
