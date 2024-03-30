require_relative '../spec_helper.rb'

describe 'Upload Endpoint' do
  def app
    Sinatra::Application
  end

  describe 'POST /upload' do
    let(:file_path) { File.expand_path('../support/data.csv', __dir__) }
    let(:uploaded_file) { Rack::Test::UploadedFile.new(file_path, 'text/csv') }
    let(:mock_payload) { { file: double('Multipart::Post::UploadIO') } }

    let(:api_service) { instance_double(ApiService) }
    let(:exam_service) { ExamService.new(api_service) }

    before do
      allow(ApiService).to receive(:new).and_return(api_service)
      allow(ExamService).to receive(:new).and_return(exam_service)
      allow(UploadCSVService).to receive(:create_payload).and_return(mock_payload)
    end

    it 'returns 200 when a file is uploaded' do
      allow(api_service).to receive(:send_file).with(mock_payload)

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
      let(:wrong_file_path) { File.expand_path('../support/test_data.rb', __dir__) }
      let(:wrong_file) { Rack::Test::UploadedFile.new(wrong_file_path, 'text/csv') }

      it 'returns 400 and error message' do

        post '/upload', csvFile: wrong_file

        expect(last_response.status).to eq 400
        expect(JSON.parse(last_response.body)).to eq({"message"=>"Invalid file format", "success"=>false})
      end
    end

    context 'server error' do
      it 'returns 500 when an error occurs during import' do
        allow(api_service).to receive(:send_file).and_raise(ApiServerError, 'Server Error')

        post '/upload', csvFile: uploaded_file

        expect(last_response.status).to eq(500)
        expect(JSON.parse(last_response.body)).to eq({"error"=>true, "message"=>"An error has occurred. Try again"})
      end
    end
  end
end
