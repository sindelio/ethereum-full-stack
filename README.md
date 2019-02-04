# Ethereum Private Network

A private Ethereum network, manually configured for test purposes.

## FEATURES

- Proof-Of-Authority consensus algorithm, more interesting for testing
- Custom Genesis file/block generated with Puppeth
- Private 2-node network, node discovery is disallowed
- Each node is an instance of Go-Ethereum (Geth)
- Nodes are containerized with Docker
- Containers are controlled with a Docker-compose file
- Manual configuration of the Geth start options
- Basic accounting for each node
- HTTP management APIs activated (over Remote Process Call and Web Sockets), meaning one can use web3 to programmatically interact with the nodes

# IMPORTANT NOTES

- This private network is using POA (clique), to use POW create another genesis file with puppeth, it will be easier than trying to manually edit the genesis file.
- The genesis.json file was generated via Puppeth. It's a great tool to create genesis files.
- The static-nodes.json file has to live in <datadir>/geth/ because it's read automatically from that path. This file specifies some nodes (usually bootnodes) to connect to automatically when the node is started.
- A bootnode is a trusted node within the network, one that holds a canonical chain that other nodes copy to themselves.
- Sealer is the name given to miner nodes in POA consensus.
- Web3 was used to decrypt and see the private key of the nodes' accounts.
- If you need event based communication with the nodes, use the WS HTTP API instead of the RPC HTTP API. As of this date, events are not supported by the RPC HTTP API.
- There are commentaries in the code, you will find them useful.