require_relative '../spec_helper.rb'
require 'json'
require 'faraday'
require 'faraday/multipart'
RSpec.describe 'Upload Endpoint' do
  def app
    Sinatra::Application
  end
    describe 'POST /upload' do
      let(:file_path) { File.expand_path('../support/data.csv', __dir__) }
      let(:uploaded_file) { Rack::Test::UploadedFile.new(file_path, 'text/csv') }
      let(:mock_conn) { double('Faraday::Connection') }
      let(:mock_file_part) { double('Faraday::Multipart::FilePart') }

      before do
        allow(Faraday).to receive(:new).with(url: 'http://backend:3001').and_return(mock_conn)
        allow(Faraday::Multipart::FilePart).to receive(:new).with(any_args).and_return(mock_file_part)
      end
    it 'returns 200 when a file is uploaded' do
      allow(mock_conn).to receive(:post).with('import', { :file => mock_file_part }).and_return(double('response', status: 200))
      post '/upload', csvFile: uploaded_file
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)).to eq({"message"=>"Data imported successfully", "success"=>true})
    end
    it 'returns 400 when no file is uploaded' do
      post '/upload'
      allow(mock_conn).to receive(:post).with('import', nil).and_return(double('response', status: 400))
      expect(last_response.status).to eq 400
      expect(JSON.parse(last_response.body)).to eq({"message"=>"No file was uploaded", "success"=>false})
    end


    it 'returns 500 when an error occurs during import' do
      allow(mock_conn).to receive(:post).with('import', { :file => mock_file_part }).and_raise(Faraday::ServerError)
      post '/upload', csvFile: uploaded_file
      expect(last_response.status).to eq(500)
      expect(JSON.parse(last_response.body)).to eq({"error"=>true, "message"=>"An error occurred while importing data. Try again"})
    end
  end
end
