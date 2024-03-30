require 'faraday'
Dir[File.expand_path("./errors/*.rb", __dir__)].each { |file| require file }

class ApiService
  URL = 'http://backend:3001'
  EXAMS_PATH = 'tests'
  UPLOAD_CSV_PATH = 'import'

  private_constant :URL, :EXAMS_PATH, :UPLOAD_CSV_PATH

  def initialize
    @conn ||= Faraday.new(url: URL) do |builder|
      builder.request :multipart
      builder.request :url_encoded
      builder.adapter :net_http
      builder.response :raise_error, include_request: true
    end
  rescue Faraday::Error => e
    raise ApiServerError.new e.message
  end

  def get_exams(**queries)
    response = @conn.get(EXAMS_PATH, queries)
    response.body
  rescue Faraday::ResourceNotFound => e
    raise ApiNotFoundError.new e.message, e.response_body
  rescue Faraday::ServerError, Faraday::ConnectionFailed => e
    raise ApiServerError.new e.message
  end

  def get_exam_by_token(token)
    response = @conn.get("#{EXAMS_PATH}/#{token}")
    response.body
  rescue Faraday::ResourceNotFound => e
    raise ApiNotFoundError.new e.message, e.response_body
  rescue Faraday::ServerError, Faraday::ConnectionFailed => e
    raise ApiServerError.new e.message
  end

  def send_file(payload)
    @conn.post(UPLOAD_CSV_PATH, payload)
  rescue Faraday::BadRequestError => e
    raise ApiBadRequestError.new e.message
  rescue Faraday::ServerError, Faraday::ConnectionFailed => e
    raise ApiServerError.new e.message
  end
end
