require_relative '../spec_helper.rb'
require_relative '../support/test_data.rb'
require 'json'
require 'faraday'

RSpec.describe 'Server' do
  def app
    Sinatra::Application
  end

  describe 'GET /data' do
    it 'returns the exams data' do
      conn = instance_double(Faraday::Connection)
      allow(Faraday).to receive(:new).and_return(conn)
      allow(conn).to receive(:get).with('tests').and_return(double(body: api_response.to_json))

      response = get '/data'

      data = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(data).to be_instance_of Array
      expect(data).to eq(JSON.parse(api_response.to_json))
    end

    context 'with token params' do
      it 'returns the specific exams data' do
        conn = instance_double(Faraday::Connection)
        allow(Faraday).to receive(:new).and_return(conn)
        allow(conn).to receive(:get).with("tests/IQCZ17").and_return(double(body: api_response.to_json))

        response = get '/data?token=IQCZ17'

        data = JSON.parse(response.body)

        expect(response.status).to eq 200
        expect(data).to be_instance_of Array
        expect(data).to eq(JSON.parse(api_response.to_json))
      end
    end
  end
end
