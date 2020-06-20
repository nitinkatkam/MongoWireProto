class SocketWrapper
    def initialize(socket)
        @socket = socket
    end
    def send(data, flags)
        File.open('socketCaptureSend.dat', 'a') { |file|
            file.write(data)
        }
        @socket.send(data, flags)
    end
    def recv(len)
        data = @socket.recv(len)
        File.open('socketCaptureRecv.dat', 'a') { |file|
            file.write(data)
        }
        data
    end
end