class ApiServerError < StandardError
  attr_reader :status

  def initialize(message)
    super(message)
    @status = 500
  end
end
