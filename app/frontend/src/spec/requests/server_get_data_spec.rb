require_relative '../spec_helper.rb'
require_relative '../support/test_data.rb'
require_relative '../../services/api_service.rb'
require 'json'
require 'faraday'

RSpec.describe 'Server' do
  def app
    Sinatra::Application
  end

  describe 'GET /data' do
    let(:mock_conn) { instance_double(Faraday::Connection) }
    let(:mock_response) { instance_double(Faraday::Response) }

    before do
      allow(ApiService).to receive(:connection).and_return(mock_conn)
    end

    it 'returns the exams data' do
      api_response_json = api_response.to_json

      allow(ApiService).to receive(:get_exams).with(mock_conn).and_return(mock_response)
      allow(mock_response).to receive(:body).and_return(api_response_json)
      allow(mock_response).to receive(:status).and_return(200)

      response = get '/data'

      data = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(data).to be_instance_of Array
      expect(data).to eq(JSON.parse(api_response_json))
    end

    context 'with token params' do
      it 'returns the specific exams data' do
        api_response_json = [api_response[0]].to_json
        token = 'IQCZ17'

        allow(ApiService).to receive(:get_exam_by_token).with(mock_conn, token).and_return(mock_response)
        allow(mock_response).to receive(:body).and_return(api_response_json)
        allow(mock_response).to receive(:status).and_return(200)

        response = get "/data?token=#{token}"

        data = JSON.parse(response.body)

        expect(response.status).to eq 200
        expect(data).to be_instance_of Array
        expect(data).to eq(JSON.parse(api_response_json))
      end
    end

    context "with unregistered token" do
      it "returns an empty array" do
        api_response_json = [].to_json
        token = 'blabla'

        allow(ApiService).to receive(:get_exam_by_token).with(mock_conn, token).and_return(mock_response)
        allow(mock_response).to receive(:body).and_return(api_response_json)
        allow(mock_response).to receive(:status).and_return(200)

        response = get "/data?token=#{token}"

        data = JSON.parse(response.body)

        expect(response.status).to eq 200
        expect(data).to be_instance_of Array
        expect(data).to eq(JSON.parse(api_response_json))
      end
    end

    context "when occurs server error" do
      it "returns an error message at /data endpoint" do
        api_response_json = { error: true,  message: 'An error has occurred. Try again' }.to_json

        allow(ApiService).to receive(:get_exams).and_raise(Faraday::ServerError)
        allow(mock_response).to receive(:body).and_return(api_response_json)
        allow(mock_response).to receive(:status).and_return(500)

        response = get '/data'

        data = JSON.parse(response.body)

        expect(response.status).to eq 500
        expect(data).to eq(JSON.parse(api_response_json))
      end
    end

  end
end
