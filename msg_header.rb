class StandardMessageHeader
  def initialize(message_length = nil, request_id = nil, response_to = nil, op_code = nil)
    @message_length = message_length
    @request_id = request_id
    @response_to = response_to
    @op_code = op_code

    @placeholder = placeholder
  end

  def placeholder
    @placeholder
  end

  def placeholder=(placeholder)
    @placeholder = placeholder
  end

  attr_accessor :message_length, :request_id, :response_to, :op_code
#  attr_reader :message_length, :request_id, :response_to, :op_code
#  attr_writer :message_length, :request_id, :response_to, :op_code
end
