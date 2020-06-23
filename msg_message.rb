require './msg_base'


class MessageMessage < BaseMessage
  def initialize(header: nil, flags: 0, kind: 0, sections: 0)
    @header = header
    @flags = flags
    @sections = sections
  end

  def calculate_message_size
    message_length = @header.my_size + 4
    if @header != nil
      @header.message_length = message_length
    end
    message_length
  end

  attr_accessor :flags, :sections
end