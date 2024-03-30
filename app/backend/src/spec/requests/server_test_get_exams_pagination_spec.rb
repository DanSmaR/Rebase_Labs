require_relative '../spec_helper.rb'
require_relative '../support/test_data.rb'
Dir[File.expand_path("../../database/*.rb", __dir__)].each { |file| require file }

RSpec.describe 'Server' do
  describe 'GET /tests?page=2&limit=2' do
    before(:each) do
      DatabaseSetup.seed(DBManager.conn)
    end

    after(:each) do
      DatabaseSetup.clean(DBManager.conn)
      DBManager.conn.exec("ALTER SEQUENCE tests_id_seq RESTART WITH 1")
    end

    it 'returns the next exams from database skipping the first two one\'s' do
      response = get '/tests?page=2&limit=2'

      data = JSON.parse(response.body)

      expect(data).to eq({
        "total_pages" => 2,
        "previous" => { "limit" => 2, "page" => 1 },
        "next" => nil,
        "results" => api_response_all['results'][0..1]
      })
    end

    context "when the result is empty" do
      it 'returns a 404 status code and the result' do
        DatabaseSetup.clean(DBManager.conn)

        response = get '/tests?page=2&limit=2'

        data = JSON.parse(response.body)

        expect(response.status).to eq 404
        expect(data).to eq({
          "total_pages" => 0,
          "previous" => nil,
          "next" => nil,
          "results" => []
        })
      end
    end

    context "when occurs a server error" do
      it "returns status code 500 and an error message" do
        allow(ExamDataBuilder).to receive(:get_exams_from_db).and_raise(DataBaseError)

        response = get '/tests?page=2&limit=2'

        data = JSON.parse(last_response.body)

        expect(last_response.status).to eq 500
        expect(data).to eq({ "error"=> true,  "message"=> 'An error has occurred. Try again' })
      end
    end
  end
end
