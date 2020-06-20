require 'socket'
require 'bindata'
require 'bson'
require './msg_header'

def read_to_char(stream, delim)
  buf = nil
  loop do
    if buf == nil
      buf = stream.recv(1)
    else
      buf += stream.recv(1)
    end
    if buf[buf.length-1] == delim
      break
    end
  end
  buf
end

def fetch_uint32(stream)
  stream.recv(4).unpack('V').first
end

s = TCPServer.open(27027)
c = s.accept

req_std_header = StandardMessageHeader.new

#TODO Make StandardMessageHeader capable of fetching these
req_std_header.message_length = fetch_uint32(c)
req_std_header.request_id = fetch_uint32(c)
req_std_header.response_to = fetch_uint32(c)
req_std_header.op_code = fetch_uint32(c)

flags = fetch_uint32(c)
#coll_name = c.gets("\0").chomp("\0") #Cannot mix recv and gets
coll_name = read_to_char(c, "\0").chomp("\0")
num_skip = fetch_uint32(c)
num_return = fetch_uint32(c)
read_so_far = 28 + coll_name.length + 1

remaining_len = req_std_header.message_length - read_so_far
remaining_data = c.recv remaining_len

bson_len = ((remaining_data.slice 0, 4).unpack 'V').first
bson_data = remaining_data.slice 4, bson_len

optional_selector_len = remaining_len - (4 + bson_len + 1)

#p remaining_data

c.close
s.close

buffer = BSON::ByteBuffer.new(remaining_data.slice 0, bson_len+4)
d = BSON::Document.from_bson(buffer)
#d = BSON::Document.from_bson(BSON::ByteBuffer.new(bson_data))
#d = BSON::Document.from_bson(bson_data, **{ mode: :bson })

p d


