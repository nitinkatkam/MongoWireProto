require 'socket'
require './msg_query'
require './msg_reply'


class Client
    def initialize
        @counter_request_id = 0
    end


    def start
        c = TCPSocket.open('127.0.0.1', 27017)

        #Construct a query message
        std_header = StandardMessageHeader.new
        std_header.op_code = OP_QUERY
        std_header.response_to = 0 #req_msg.header.request_id
        std_header.request_id = @counter_request_id
        #Set the message length later
        #std_header.message_length
        @counter_request_id += 1
    
        query_msg = QueryMessage.new
        query_msg.header = std_header
        query_msg.flags = 0
        query_msg.collection_name = "admin.$cmd"
        query_msg.num_skip = 0
        query_msg.num_return = 1
    
        #query_msg.reply_doc
        doc = BSON::Document.new
        doc[:isMaster] = 1
        doc[:hostInfo] = 'Nitins-MBP:27017'
        doc[:client] = {
            application: {
                name: 'MongoDB Shell'
            },
            driver: {
                name: 'MongoDB Internal Client',
                version: '4.2.2'
            },
            os: {
                type: 'Darwin',
                name: 'Mac OS X',
                architecture: 'x86_64',
                version: '19.5.0'
            }
        }
        query_msg.query_doc = doc
    
        query_msg.query_doc_buffer = query_msg.query_doc.to_bson
        std_header.message_length = query_msg.query_doc_buffer.length + 16 + 12 + query_msg.collection_name.length + 1

        MessageWriter.writeMessage(c, query_msg)

        #Parse the reply message
        reply_msg = MessageParser.parse(c)

        c.close

        p reply_msg
    end
end