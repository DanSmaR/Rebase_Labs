require_relative '../spec_helper.rb'
require_relative '../../services/exam_service.rb'
require_relative '../../services/api_service.rb'
require_relative '../support/test_data.rb'

describe ExamService do
  let(:token) { 'ST7APU' }
  let(:api_service) { instance_double(ApiService) }
  subject(:exam_service) { ExamService.new(api_service) }

  describe '.initialize' do
    it 'instantiate a api_service variable' do
      expect(exam_service.instance_variable_get(:@api_service)).to eq api_service
    end
  end

  describe '.fetch_data' do
    context "by token" do
      it 'returns a specific exam' do
        api_response = api_response_by_token.to_json

        allow(api_service).to receive(:get_exam_by_token).with(token) { api_response }

        response = exam_service.fetch_data(nil, nil, token)

        expect(response).to eq api_response
      end
    end

    context "by page and limit queries" do
      it 'returns a range of exams' do
        api_response = api_response_page_1.to_json
        page = 1
        limit = 2

        allow(api_service).to receive(:get_exams).with(page:, limit:) { api_response }

        response = exam_service.fetch_data(page, limit, nil)

        expect(response).to eq api_response
      end
    end

    describe ".send_file" do
      it 'successfully' do
        payload = { file: 'file'}

        allow(api_service).to receive(:send_file).with(payload)

        exam_service.send_file(payload)
      end
    end

  end
end
