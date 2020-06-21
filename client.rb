require 'socket'
require './msg_query'
require './msg_reply'


class Client
    def initialize
        @counter_request_id = 0
    end


    def start
        c = TCPSocket.open('127.0.0.1', 12121)

        std_header = StandardMessageHeader.new request_id: @counter_request_id
        @counter_request_id += 1



        #
        # isMaster
        #

        doc = BSON::Document.new(
            isMaster: 1,
            hostInfo: 'Nitins-MBP:27017',
            client: {
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
        )
        query_msg = QueryMessage.new(header: std_header, collection_name: "admin.$cmd", doc: doc)
        MessageWriter.writeMessage(c, query_msg)

        reply_msg = MessageParser.parse(c)



        #
        # whatsmyuri
        #

        doc = BSON::Document.new(
            whatsmyuri: 1
        )
        query_msg = QueryMessage.new(header: std_header, collection_name: "admin.$cmd", doc: doc)
        MessageWriter.writeMessage(c, query_msg)

        reply_msg = MessageParser.parse(c)



        #
        # buildInfo
        #

        doc = BSON::Document.new(
            buildInfo: 1
        )
        query_msg = QueryMessage.new(header: std_header, collection_name: "admin.$cmd", doc: doc)
        MessageWriter.writeMessage(c, query_msg)

        reply_msg = MessageParser.parse(c)



        #
        # startupWarnings
        #

        doc = BSON::Document.new(
            getLog: 'startupWarnings'
        )
        query_msg = QueryMessage.new(header: std_header, collection_name: "admin.$cmd", doc: doc)
        MessageWriter.writeMessage(c, query_msg)

        reply_msg = MessageParser.parse(c)



        #
        # getFreeMonitoringStatus
        #

        doc = BSON::Document.new(
            getFreeMonitoringStatus: 1.0
        )
        query_msg = QueryMessage.new(header: std_header, collection_name: "admin.$cmd", doc: doc)
        MessageWriter.writeMessage(c, query_msg)

        reply_msg = MessageParser.parse(c)



        #
        # buildInfo
        #

        doc = BSON::Document.new(
            buildInfo: 1.0
        )
        query_msg = QueryMessage.new(header: std_header, collection_name: "admin.$cmd", doc: doc)
        MessageWriter.writeMessage(c, query_msg)

        reply_msg = MessageParser.parse(c)



        #
        # buildInfo
        #

        doc = BSON::Document.new(
            getCmdLineOpts: 1.0
        )
        query_msg = QueryMessage.new(header: std_header, collection_name: "admin.$cmd", doc: doc)
        MessageWriter.writeMessage(c, query_msg)

        reply_msg = MessageParser.parse(c)



        #
        # replSetGetStatus
        #

        doc = BSON::Document.new(
            replSetGetStatus: 1.0,
            forShell: 1.0
        )
        query_msg = QueryMessage.new(header: std_header, collection_name: "admin.$cmd", doc: doc)
        MessageWriter.writeMessage(c, query_msg)

        reply_msg = MessageParser.parse(c)



        #
        # listDatabases
        #

        doc = BSON::Document.new(
            listDatabases: 1.0,
            nameOnly: false
        )
        query_msg = QueryMessage.new(header: std_header, collection_name: "admin.$cmd", doc: doc)
        MessageWriter.writeMessage(c, query_msg)

        reply_msg = MessageParser.parse(c)



        #
        # listCollections
        #

        doc = BSON::Document.new(
            listCollections: 1.0,
            filter: {},
            nameOnly: true,
            authorizedCollections: true
        )
        query_msg = QueryMessage.new(header: std_header, collection_name: "admin.$cmd", doc: doc)
        MessageWriter.writeMessage(c, query_msg)

        reply_msg = MessageParser.parse(c)






        c.close

        p reply_msg.doc
    end
end