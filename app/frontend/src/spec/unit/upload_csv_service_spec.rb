require_relative '../spec_helper.rb'
require_relative '../../services/upload_csv_service'

describe UploadCSVService do
  context '.validate' do
    it 'returns successfull message if it is a csv file' do
      fake_file_params = {
        tempfile: 'file.csv',
        filename: 'filename.csv'
      }

      expected_result = { success: true, tmpfile: fake_file_params[:tempfile] }

      validation_res = UploadCSVService.validate(fake_file_params)

      expect(validation_res).to eq expected_result
    end

    it 'returns error message if no file was uploaded' do
      expected_result = { success: false, message: 'No file was uploaded' }

      validation_res = UploadCSVService.validate({})
      expect(validation_res).to eq expected_result

      validation_res = UploadCSVService.validate('undefined')
      expect(validation_res).to eq expected_result
    end

    it 'returns error message if it is not csv file' do
      expected_result = { success: false, message: 'Invalid file format' }

      fake_file_params = {
        tempfile: 'file.rb',
        filename: 'filename.rb'
      }

      validation_res = UploadCSVService.validate(fake_file_params)

      expect(validation_res).to eq expected_result
    end
  end

  context ".create_payload" do
    let(:file_path) { File.expand_path('../support/data.csv', __dir__) }
    let(:mock_file_part) { double('Faraday::Multipart::FilePart') }
    let(:uploaded_file) { Rack::Test::UploadedFile.new(file_path, 'text/csv') }

    it 'returns a payload with the file' do
      allow(Faraday::Multipart::FilePart).to receive(:new).with(uploaded_file, 'text/csv').and_return(mock_file_part)

      payload = UploadCSVService.create_payload(uploaded_file)

      expect(payload).to eq({ file: mock_file_part })
    end
  end

end
