require 'json'
require_relative './spec_helper.rb'
require_relative '../database/database_setup.rb'
require_relative '../database/db_manager.rb'

RSpec.describe 'Server' do

  def app
    Sinatra::Application
  end

  describe 'POST /import' do
    before do
      allow(DatabaseSetup).to receive(:prepare_statements)
      allow(DatabaseSetup).to receive(:insert_csv_data)
    end
    context 'when a file is uploaded' do
      it 'returns a success response' do
        file_path = File.expand_path('./support/data.csv', __dir__)
        post '/import', file: Rack::Test::UploadedFile.new(file_path, 'text/csv')

        expect(last_response).to be_ok
        expect(last_response.body).to eq({ message: 'Data imported successfully' }.to_json)

        expect(DatabaseSetup).to have_received(:prepare_statements)
        expect(DatabaseSetup).to have_received(:insert_csv_data) do |arg|
          expect(arg).to match(/\.csv\z/)
        end
      end
    end

    context 'when no file is imported' do
      it 'returns a bad request response' do
        post '/import'
        expect(last_response).to be_bad_request
        expect(last_response.body).to eq({ message: 'No file was uploaded' }.to_json)
      end
    end

    context "when occurs a database error" do
      it "returns a internal server error response" do
        allow(DatabaseSetup).to receive(:prepare_statements).and_raise(StandardError.new('An error occurred while preparing the statement'))

        file_path = File.expand_path('./support/data.csv', __dir__)
        post '/import', file: Rack::Test::UploadedFile.new(file_path, 'text/csv')

        expect(last_response).to be_server_error
        expect(last_response.body).to eq({ message: 'An error occurred while importing data. Try again' }.to_json)
      end
    end

  end
end
