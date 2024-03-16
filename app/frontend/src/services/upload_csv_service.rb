require 'faraday'
require 'faraday/multipart'

class UploadCSVService
  def self.validate(params)
    unless params && params != 'undefined' &&
      (tmpfile = params[:tempfile]) &&
      (name = params[:filename])

      return { success: false, message: 'No file was uploaded' }
    end

    unless name.match?(/\.csv\z/)
      return { success: false, message: 'Invalid file format' }
    end

    { success: true, tmpfile: }
  end

  def self.create_payload(file)
    { file: Faraday::Multipart::FilePart.new(file, 'text/csv') }
  end
end
