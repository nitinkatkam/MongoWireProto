require './util_bstream_reader'
require './msg_types'
require './msg_query'
require './msg_reply'
require './socket_wrapper'

# Parses incoming messages
class MessageParser
    def self.parse(c)
        c = SocketWrapper.new(c)

        std_header = StandardMessageHeader.new
        std_header.message_length = fetch_uint32(c)
        std_header.request_id = fetch_uint32(c)
        std_header.response_to = fetch_uint32(c)
        std_header.op_code = fetch_uint32(c)

        if std_header.op_code == OP_QUERY
            query_msg = QueryMessage.new
            query_msg.header = std_header
          
            query_msg.flags = fetch_uint32(c)
            #coll_name = c.gets("\0").chomp("\0") #Cannot mix recv and gets
            query_msg.collection_name = read_to_char(c, "\0").chomp("\0")
            query_msg.num_skip = fetch_uint32(c)
            query_msg.num_return = fetch_uint32(c)
            read_so_far = 28 + query_msg.collection_name.length + 1
            
            remaining_len = std_header.message_length - read_so_far
            remaining_data = c.recv remaining_len
            
            bson_len = ((remaining_data.slice 0, 4).unpack 'V').first
            buffer = BSON::ByteBuffer.new(remaining_data.slice(0, bson_len))
            query_msg.doc = BSON::Document.from_bson(buffer)
                        
            optional_selector_len = remaining_len - (4 + bson_len + 1)
            #TODO Get the optional field_selector
          
            retval = query_msg
        elsif std_header.op_code == OP_REPLY
            reply_msg = ReplyMessage.new
            reply_msg.header = std_header  # 16 bytes
          
            reply_msg.flags = fetch_uint32(c)
            reply_msg.cursor_id = fetch_uint64(c)  
            reply_msg.start_from = fetch_uint32(c)
            reply_msg.num_return = fetch_uint32(c)

            read_so_far = 36
            
            remaining_len = std_header.message_length - read_so_far
            if remaining_len > 0
                remaining_data = c.recv remaining_len

                buffer = BSON::ByteBuffer.new(remaining_data)
                reply_msg.doc = BSON::Document.from_bson(buffer)
            else
                reply_msg.doc = BSON::Document.new
            end
          
            retval = reply_msg
        elsif std_header.op_code == nil
            retval = nil
        else
            p std_header
            raise Exception.new 'Unrecognized op code: ' #+ std_header.op_code.to_a
        end

        retval
    end
end