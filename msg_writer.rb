class MessageWriter
    def self.writeMessage(msg)
        if query_msg.query_doc[:isMaster] == 1
            resp_std_header = StandardMessageHeader.new
            resp_std_header.op_code = 1
            resp_std_header.response_to = req_std_header.request_id
            resp_std_header.request_id = counter_request_id
            #Set the message length later
            #resp_std_header.message_length
            counter_request_id += 1
        
            reply_msg = ReplyMessage.new
            reply_msg.flags = 0
            reply_msg.cursor_id = 0
            reply_msg.start_from = 0
            reply_msg.num_return = 1
        
            #reply_msg.reply_doc
            doc = BSON::Document.new
            doc[:ismaster] = true
            doc[:maxBsonObjectSize] = 16777216
                doc[:maxMessageSizeBytes] = 48000000
                doc[:maxWriteBatchSize] = 1000
                doc[:localTime] = Time.now.strftime('%Y-%m-%dT%H:%M:%S.%L%z') #ISO8601 with milliseconds
                doc[:maxWireVersion] = 2
                doc[:minWireVersion] = 0
            doc[:ok] = 1
            reply_msg.reply_doc = doc
        
            buff = doc.to_bson
            
            resp_std_header.message_length = buff.length + 4 + 4
        
            c.send([resp_std_header.message_length].pack('I'), 0)
            c.send([resp_std_header.request_id].pack('I'), 0)
            c.send([resp_std_header.response_to].pack('I'), 0)
            c.send([resp_std_header.op_code].pack('I'), 0)
            c.send([reply_msg.flags].pack('I'), 0)
            c.send([reply_msg.cursor_id].pack('I'), 0)
            c.send([reply_msg.start_from].pack('I'), 0)
            c.send([reply_msg.num_return].pack('I'), 0)
            c.send(buff.get_bytes(buff.length), 0)
            
        #    require 'debug'
        end
    end
end