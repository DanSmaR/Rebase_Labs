class ExamService
  def initialize(api_service)
    @api_service = api_service
  end

  def fetch_data(page, limit, token)
    if token
      response = @api_service.get_exam_by_token(token)
    else
      response = @api_service.get_exams(page:, limit:)
    end

    response
  end

  def send_file(payload)
    @api_service.send_file(payload)
  end
end
