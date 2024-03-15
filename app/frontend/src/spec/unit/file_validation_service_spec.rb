require_relative '../spec_helper.rb'
require_relative '../../services/file_validation_service.rb'

describe FileValidationService do
  context '.validate' do
    it 'returns successfull message if it is a csv file' do
      fake_file_params = {
        tempfile: 'file.csv',
        filename: 'filename.csv'
      }

      expected_result = { success: true, tmpfile: fake_file_params[:tempfile] }

      validation_res = FileValidationService.validate(fake_file_params)

      expect(validation_res).to eq expected_result
    end

    it 'returns error message if no file was uploaded' do
      expected_result = { success: false, message: 'No file was uploaded' }

      validation_res = FileValidationService.validate({})
      expect(validation_res).to eq expected_result

      validation_res = FileValidationService.validate('undefined')
      expect(validation_res).to eq expected_result
    end

    it 'returns error message if it is not csv file' do
      expected_result = { success: false, message: 'Invalid file format' }

      fake_file_params = {
        tempfile: 'file.rb',
        filename: 'filename.rb'
      }

      validation_res = FileValidationService.validate(fake_file_params)

      expect(validation_res).to eq expected_result
    end
  end
end
