require './msg_base'

class ReplyMessage < BaseMessage
  def initialize(header = nil, flags = nil, cursor_id = nil, start_from = nil, num_return = nil, reply_doc = nil)
    @header = header
    @flags = flags
    @cursor_id = cursor_id
    @start_from = start_from
    @num_return = num_return
    @reply_doc = reply_doc
  end

  attr_accessor :flags, :cursor_id, :start_from, :num_return, :reply_doc
end
