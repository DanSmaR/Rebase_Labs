require 'json'
require 'fileutils'
require_relative '../spec_helper.rb'
require_relative '../../database/database_setup.rb'
require_relative '../../database/db_manager.rb'

RSpec.describe 'Server' do
  describe 'POST /import' do
    let(:file_path) { File.expand_path('../support/data.csv', __dir__) }
    let(:uploaded_file) { Rack::Test::UploadedFile.new(file_path, 'text/csv') }
    let(:mock_conn) { double('PG::Connection') }

    before do
      allow(DBManager).to receive(:conn).and_return(mock_conn)
      allow(DatabaseSetup).to receive(:prepare_statements).with(mock_conn)
      allow(DatabaseSetup).to receive(:insert_csv_data).with(anything, mock_conn)
      allow(FileUtils).to receive(:mv)
      allow(CSVImportJob).to receive(:perform_async)
    end

    context 'when a file is uploaded' do
      it 'async job is called and returns a successfull message' do
        import_file_path = "/usr/src/app/backend/src/uploads/data.csv"
        post '/import', file: uploaded_file

        expect(FileUtils).to have_received(:mv) do |args|
          expect(args[0]).to be_a(String)
          expect(args[1]).to be_a(String)
        end
        expect(CSVImportJob).to have_received(:perform_async).with(import_file_path)
        expect(last_response).to be_ok
        expect(last_response.body).to eq({ success: true, message: 'Data imported successfully' }.to_json)
      end
    end

    context 'when no file is imported' do
      it 'returns a bad request response' do
        post '/import'
        expect(last_response).to be_bad_request
        expect(last_response.body).to eq({ sucess: false, message: 'No file was uploaded' }.to_json)
      end
    end

    context "when occurs a database error" do
      it "returns a internal server error response" do
        allow(FileUtils).to receive(:mv).and_raise(Errno::ENOENT)

        file_path = File.expand_path('../support/data.csv', __dir__)
        post '/import', file: Rack::Test::UploadedFile.new(file_path, 'text/csv')

        expect(last_response).to be_server_error
        expect(JSON.parse(last_response.body)).to eq({"error"=>true, "message"=>"An error occurred while importing data. Try again"})
      end
    end

  end
end
