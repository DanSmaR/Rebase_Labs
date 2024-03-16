require 'faraday'

class ApiService
  URL = 'http://backend:3001'
  EXAMS_PATH = 'tests'
  UPLOAD_CSV_PATH = 'import'

  private_constant :URL, :EXAMS_PATH, :UPLOAD_CSV_PATH

  def self.connection
    @conn ||= Faraday.new(url: URL) do |builder|
      builder.request :multipart
      builder.request :url_encoded
      builder.adapter :net_http
      builder.response :raise_error, include_request: true
    end
  end

  def self.get_exams(conn)
    conn.get(EXAMS_PATH)
  end

  def self.get_exam_by_token(conn, token)
    conn.get("#{EXAMS_PATH}/#{token}")
  end

  def self.send_file(conn, payload)
    conn.post(UPLOAD_CSV_PATH, payload)
  end
end
