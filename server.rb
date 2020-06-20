require './msg_query'
require './msg_writer'


class Server
    def initialize
        @counter_request_id = 0
    end


    def start
        s = TCPServer.open(27027)
        c = s.accept

        loop do
          req_msg = MessageParser.parse(c)

          p req_msg

          if req_msg.is_a?(QueryMessage)
              std_header = StandardMessageHeader.new
              std_header.op_code = OP_REPLY
              std_header.response_to = req_msg.header.request_id
              std_header.request_id = @counter_request_id
              #Set the message length later
              #std_header.message_length
              @counter_request_id += 1

              reply_msg = ReplyMessage.new
              reply_msg.header = std_header
              reply_msg.flags = 0
              reply_msg.cursor_id = 0
              reply_msg.start_from = 0
              reply_msg.num_return = 1

              doc = BSON::Document.new

              if req_msg.query_doc.has_key?(:isMaster)
                  doc[:ismaster] = true
                  doc[:maxBsonObjectSize] = 16777216
                  doc[:maxMessageSizeBytes] = 48000000
                  doc[:maxWriteBatchSize] = 1000
                  doc[:localTime] = Time.now #.strftime('%Y-%m-%dT%H:%M:%S.%L%z') #ISO8601 with milliseconds
                  doc[:maxWireVersion] = 2
                  doc[:minWireVersion] = 0
                  doc[:ok] = 1
              elsif req_msg.query_doc.has_key?(:whatsmyuri)
                  sock_domain, remote_port, remote_hostname, remote_ip = c.peeraddr
                  doc[:you] = "#{remote_ip}:#{remote_port}"
                  doc[:ok] = 1
              else
                  puts 'Unrecognized query'
                  break # TODO Handle this more elegantly
              end

              reply_msg.reply_doc = doc
              reply_msg.reply_doc_buffer = reply_msg.reply_doc.to_bson
              std_header.message_length = reply_msg.reply_doc_buffer.length + 16 + 20
              MessageWriter.writeMessage(c, reply_msg)
          else
              puts 'Unrecognized message type'
              break # TODO Handle this more elegantly
          end
        end

        c.close
        s.close        
    end
end



###
# Raw: {"length":300,"requestId":0,"responseTo":0,"opCode":2004,"flags":0,"fullCollectionName":"admin.$cmd","numberToSkip":0,"numberToReturn":1,"query":{"isMaster":1,"hostInfo":"Nitins-MBP:27017","client":{"application":{"name":"MongoDB Shell"},"driver":{"name":"MongoDB Internal Client","version":"4.2.2"},"os":{"type":"Darwin","name":"Mac OS X","architecture":"x86_64","version":"19.5.0"}}}}
###
# Raw: {"length":60,"requestId":1,"responseTo":0,"opCode":2004,"flags":0,"fullCollectionName":"admin.$cmd","numberToSkip":0,"numberToReturn":1,"query":{"whatsmyuri":1}}
###
# #<QueryMessage:0x00007f9e409335b0 @header=#<StandardMessageHeader:0x00007f9e40933e20 @message_length=63, @request_id=2, @response_to=0, @op_code=2004, @placeholder=nil>, @flags=0, @collection_name="admin.$cmd", @num_skip=0, @num_return=1,
# @query_doc={"buildinfo"=>1.0}, @field_selector=nil>
###