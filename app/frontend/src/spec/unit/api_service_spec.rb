require_relative '../spec_helper.rb'
require 'faraday'
require_relative '../../services/api_service.rb'
describe ApiService do
  let(:mock_conn) { instance_double(Faraday::Connection) }
  let(:mock_response) { double('Faraday::Response') }
  context ".connection" do
    it 'returns a Faraday connection' do
      allow(Faraday).to receive(:new).with(url: 'http://backend:3001').and_return(mock_conn)

      conn = ApiService.connection

      expect(conn).to eq mock_conn
    end
  end

  context '.get_exams' do
    it "returns a Faraday Response" do
      allow(mock_conn).to receive(:get).with('tests').and_return(mock_response)

      response = ApiService.get_exams(mock_conn)

      expect(response).to eq mock_response
    end
  end

  context ".get_exams_by_token" do
    it "returns a Faraday Response" do
      allow(mock_conn).to receive(:get).with('tests/IQCZ17').and_return(mock_response)

      response = ApiService.get_exam_by_token(mock_conn, 'IQCZ17')

      expect(response).to eq mock_response
    end
  end

  context ".send_file" do
    let(:mock_file) { double('Faraday::Multipart::FilePart') }
    it "returns a Faraday Response" do
      payload = { file: mock_file }
      allow(mock_conn).to receive(:post).with('import', payload).and_return(mock_response)

      response = ApiService.send_file(mock_conn, payload)

      expect(response).to eq mock_response
    end
  end
end
