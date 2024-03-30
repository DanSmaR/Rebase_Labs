class ApiNotFoundError < StandardError
  attr_reader :payload, :status

  def initialize(message, payload = nil)
    super(message)
    @payload = payload
    @status = 404
  end
end
