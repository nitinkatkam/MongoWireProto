require './msg_base'


class MessageMessage < BaseMessage
  def initialize(header: nil, flags: 0, kind: 0, sections: [])
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

  #TODO - Create a docs custom accessor method to return the section 0 document

  attr_accessor :flags, :sections
end