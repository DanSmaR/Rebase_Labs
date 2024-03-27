require 'json'
require 'pg'
require_relative '../spec_helper.rb'
require_relative '../support/test_data.rb'
require_relative '../../database/db_manager.rb'
require_relative '../../database/database_setup.rb'

RSpec.describe 'Server' do
  describe 'GET /tests' do
    before(:each) do
      DatabaseSetup.seed(DBManager.conn)
    end

    after(:each) do
      DatabaseSetup.clean(DBManager.conn)
      DBManager.conn.exec("ALTER SEQUENCE tests_id_seq RESTART WITH 1")
    end

    it 'returns the exams data' do
      response = get '/tests'

      data = JSON.parse(response.body)

      expect(data).to eq(api_response)
    end

    context "when the result is empty" do
      it 'returns a 404 status code and the result' do
        DatabaseSetup.clean(DBManager.conn)

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

        response = get "/tests/#{token}"

        data = JSON.parse(response.body)

        expect(data).to eq([api_response['results'][0]])
      end
    end

    context "when token does not exist" do
      it "returns a 404 status code and and an empty array" do
        token = 'foo'

        response = get "/tests/#{token}"

        data =JSON.parse(response.body)

        expect(response.status).to eq 404
        expect(data).to eq []
      end
    end
  end

  describe 'GET /tests' do
    context "when occurs a server error" do
      it "returns status code 500 and an error message" do
        mock_conn = instance_double(PG::Connection)
        allow(DBManager).to receive(:conn).and_return(mock_conn)

        allow(mock_conn).to receive(:exec_params).and_raise(PG::Error)

        get "/tests/IQCZ17"

        data = JSON.parse(last_response.body)

        expect(last_response.status).to eq 500
        expect(data).to eq({ "error"=> true,  "message"=> 'An error has occurred. Try again' })
      end
    end
  end
end
