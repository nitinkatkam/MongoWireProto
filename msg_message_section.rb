class MessageMessageSection
  def initialize(kind: 0, doc: nil, checksum: 0)
    @kind = kind
    @doc = doc
    @checksum = checksum
  end

  def calculate_message_size
    message_length = -1
    message_length
  end

  attr_accessor :kind, :doc, :checksum
end
