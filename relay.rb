require './msg_query'
require './msg_writer'
require 'json'
require 'net/http'

class Relay
  def initialize(port=27017)
    @counter_request_id = 0
    @port = port
  end


  def start
    s = TCPServer.open(@port)
    c = s.accept

    r = TCPSocket.open('127.0.0.1', 27017)

    loop do
      req_msg = MessageParser.parse(c)
      MessageWriter.writeMessage(r, req_msg)
      resp_msg = MessageParser.parse(r)
      MessageWriter.writeMessage(c, resp_msg)
    end
  end
end