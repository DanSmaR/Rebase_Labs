require_relative '../spec_helper.rb'
require 'json'
require 'faraday'
require 'faraday/multipart'
RSpec.describe 'Upload Endpoint' do
  def app
    Sinatra::Application
  end
  describe 'POST /upload' do
    let(:mock_conn) { instance_double(Faraday::Connection) }
    let(:mock_response) { instance_double(Faraday::Response) }
    let(:file_path) { File.expand_path('../support/data.csv', __dir__) }
    let(:uploaded_file) { Rack::Test::UploadedFile.new(file_path, 'text/csv') }
    let(:mock_file_part) { double('Faraday::Multipart::FilePart') }

    before do
      allow(ApiService).to receive(:connection).and_return(mock_conn)
      allow(Faraday::Multipart::FilePart).to receive(:new).with(any_args).and_return(mock_file_part)
    end

    it 'returns 200 when a file is uploaded' do
      allow(ApiService).to receive(:send_file).with(mock_conn, { :file => mock_file_part }).and_return(mock_response)

      post '/upload', csvFile: uploaded_file

      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)).to eq({"message"=>"Data imported successfully", "success"=>true})
    end

    it 'returns 400 when no file is uploaded' do
      post '/upload'

      expect(last_response.status).to eq 400
      expect(JSON.parse(last_response.body)).to eq({"message"=>"No file was uploaded", "success"=>false})
    end

    context "when a no csv file type is uploaded" do
      let(:file_path) { File.expand_path('../support/test_data.rb', __dir__) }
      let(:uploaded_file) { Rack::Test::UploadedFile.new(file_path, 'text/csv') }

      it 'returns 400 and error message' do

        post '/upload', csvFile: uploaded_file

        expect(last_response.status).to eq 400
        expect(JSON.parse(last_response.body)).to eq({"message"=>"Invalid file format", "success"=>false})
      end
    end

    context 'server error' do
      it 'returns 500 when an error occurs during import' do
        allow(ApiService).to receive(:send_file).with(mock_conn, { :file => mock_file_part }).and_raise(Faraday::ServerError)

        post '/upload', csvFile: uploaded_file

        expect(last_response.status).to eq(500)
        expect(JSON.parse(last_response.body)).to eq({"error"=>true, "message"=>"An error has occurred. Try again"})
      end
    end
  end
end
