require './msg_query'
require './msg_reply'
require './socket_wrapper'

# Writes messages to the network
class MessageWriter
    def self.writeMessage(c, msg)
        c = SocketWrapper.new(c)

        msg.calculate_message_size

        c.send([msg.header.message_length].pack('I'), 0)
        c.send([msg.header.request_id].pack('I'), 0)
        c.send([msg.header.response_to].pack('I'), 0)
        c.send([msg.header.op_code].pack('I'), 0)

        if msg.is_a?(ReplyMessage)
            c.send([msg.flags].pack('I'), 0)
            c.send([msg.cursor_id].pack('Q'), 0)
            c.send([msg.start_from].pack('I'), 0)
            c.send([msg.num_return].pack('I'), 0)
            
            bson_bytes = msg.doc_buffer.get_bytes(msg.doc_buffer.length)
            c.send(bson_bytes, 0)
        elsif msg.is_a?(QueryMessage)
            c.send([msg.flags].pack('I'), 0)
            c.send(msg.collection_name + "\0", 0)
            c.send([msg.num_skip].pack('I'), 0)
            c.send([msg.num_return].pack('I'), 0)

            bson_bytes = msg.doc_buffer.get_bytes(msg.doc_buffer.length)
            c.send(bson_bytes, 0)
        end
    end
end