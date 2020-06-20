require 'socket'
require 'bindata'
require 'bson'
require './msg_header'
require './msg_query'
require './msg_reply'
require './util_bstream_reader'
require './msg_parser'

counter_request_id = 500

s = TCPServer.open(27027)
c = s.accept

req_msg = MessageParser.parse(c)
p req_msg

c.close
s.close

#require 'debug'