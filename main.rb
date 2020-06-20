require 'socket'
require 'bindata'
require 'bson'
require './msg_header'
require './msg_query'
require './msg_reply'
require './util_bstream_reader'
require './msg_parser'
require './server'
require './client'


for arg in ARGV
    if arg == 'server'
        s = Server.new
        s.start
    elsif arg == 'client'
        c = Client.new
        c.start
    end        
end

#require 'debug'