class ApiBadRequestError < StandardError
  attr_reader :status

  def initialize(message)
    super(message)
    @status = 400
  end
end
