# WireProto

This repo demonstrates how to use Ruby to speak the MongoDB wire protocol.

## Getting Started

1. Clone the repo
2. Run "bundle install"
3. ./run_server.sh and connect with Mongo shell to port 27027  OR  ./run_client.sh to connect to 127.0.0.1:12121

## Use Cases

* Enforcing document-level security for Compass or BI tool users
* Serve realtime data from APIs
* Enforce password policies (complexity, aging)
* Stored procedures and triggers (Eg. server-side logic for mobile clients)
