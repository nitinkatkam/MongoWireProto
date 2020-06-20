require './msg_base'


class QueryMessage < BaseMessage
  def initialize(header = nil, flags = nil, collection_name = nil, num_skip = nil, num_return = nil, query_doc = nil, field_selector = nil)
    @header = header
    @flags = flags
    @collection_name = collection_name
    @num_skip = num_skip
    @num_return = num_return
    @query_doc = query_doc
    @field_selector = field_selector
  end

  attr_accessor :flags, :collection_name, :num_skip, :num_return, :query_doc, :field_selector, :query_doc_buffer
end
