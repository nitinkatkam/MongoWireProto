require 'socket'
require 'bindata'
require 'bson'

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

s = TCPServer.open(27117)
c = s.accept

msg_len = ((c.recv 4).unpack 'V').first
request_id = ((c.recv 4).unpack 'V').first
response_to = ((c.recv 4).unpack 'V').first
op_code = ((c.recv 4).unpack 'V').first
flags = ((c.recv 4).unpack 'V').first
#coll_name = c.gets("\0").chomp("\0")
coll_name = (read_to_char c, "\0").chomp("\0")
num_skip = ((c.recv 4).unpack 'V').first
num_return = ((c.recv 4).unpack 'V').first
read_so_far = 28 + coll_name.length + 1

remaining_len = msg_len - read_so_far
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


