require_relative '../spec_helper.rb'
require_relative '../support/test_data.rb'
require 'json'

describe 'GET /data' do

  def app
    Sinatra::Application
  end

  let(:api_service) { instance_double(ApiService) }
  let(:exam_service) { ExamService.new(api_service) }

  before do
    allow(ApiService).to receive(:new).and_return(api_service)
    allow(ExamService).to receive(:new).and_return(exam_service)
  end

  context "?page=1&limit=2" do
    let(:page) { 1 }
    let(:limit) { 2 }
    let(:api_response) {  api_response_page_1.to_json}

    it 'returns the first exams page' do
      allow(api_service).to receive(:get_exams).with(page:, limit:).and_return(api_response)

      response = get "/data?page=#{page}&limit=#{limit}"

      data = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(data).to eq(JSON.parse(api_response))
    end

    it 'returns empty results when there is no exams' do
      empty_api_response = [].to_json

      allow(api_service)
        .to receive(:get_exams)
        .with(page:, limit:)
        .and_raise(ApiNotFoundError.new('Server Error', empty_api_response))

      response = get "/data?page=#{page}&limit=#{limit}"

      data = JSON.parse(response.body)

      expect(response.status).to eq 404
      expect(data).to eq(JSON.parse(empty_api_response))
    end
  end

  context 'with token params' do
    let(:api_response) { api_response_by_token.to_json }
    let(:token) { 'IQCZ17' }

    it 'returns the specific exams data' do

      allow(api_service).to receive(:get_exam_by_token).with(token).and_return(api_response)

      response = get "/data?token=#{token}"

      data = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(data).to eq(JSON.parse(api_response))
    end
  end

  context "with unregistered token" do
    let(:api_response) { [].to_json }
    let(:token) { 'foo' }
    it "returns an empty array" do

      allow(api_service)
        .to receive(:get_exam_by_token)
        .with(token)
        .and_raise(ApiNotFoundError.new('Server Error', api_response))

      response = get "/data?token=#{token}"

      data = JSON.parse(response.body)

      expect(response.status).to eq 404
      expect(data).to eq(JSON.parse(api_response))
    end
  end

  context "when occurs server error" do
    let(:api_response) { { error: true,  message: 'An error has occurred. Try again' }.to_json }

    it "returns an error message at /data?page=1 endpoint" do
      allow(api_service).to receive(:get_exams).and_raise(ApiServerError, 'Server Error')

      response = get '/data?page=1'

      data = JSON.parse(response.body)

      expect(response.status).to eq 500
      expect(data).to eq(JSON.parse(api_response))
    end

    it "returns an error message at /data?token=ST7APU endpoint" do
      allow(api_service).to receive(:get_exam_by_token).and_raise(ApiServerError, 'Server Error')

      response = get '/data?token=ST7APU'

      data = JSON.parse(response.body)

      expect(response.status).to eq 500
      expect(data).to eq(JSON.parse(api_response))
    end
  end
end
