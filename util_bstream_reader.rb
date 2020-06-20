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
