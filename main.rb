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
require 'optparse'


def start_in_mode(cmdline_params)
    case cmdline_params[:mode]
    when 'server'
        s = cmdline_params.has_key?('port') ? Server.new(cmdline_params[:port]) : Server.new
        s.start
    when 'client'
        c = cmdline_params.has_key?('port') ? Client.new(cmdline_params[:port]) : Client.new
        c.start
    end

    # for arg in ARGV
    #     if arg == 'server'
    #         s = Server.new
    #         s.start
    #     elsif arg == 'client'
    #         c = Client.new
    #         c.start
    #     end
    # end
end


def main
    cmdline_params = {}

    OptionParser.new do |iter_cmdline|
        iter_cmdline.on('--mode STARTMODE', 'Startup as client or server') do |start_mode|
            cmdline_params[:mode] = start_mode
        end

        # TODO make this optional
        # iter_cmdline.on('--host HOST', 'Host to connect to') do |port_num|
        #     cmdline_params[:port] = port_num
        # end

        iter_cmdline.on('--port PORT', 'Port number to connect/listen') do |port_num|
            cmdline_params[:port] = port_num
        end
    end.parse!

    start_in_mode cmdline_params
end


#Invoke the main method
main


#require 'debug'