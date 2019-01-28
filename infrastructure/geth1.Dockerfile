FROM ubuntu:18.04

ENV PATH=/usr/lib/go-1.9/bin:$PATH

RUN \
  apt-get update && apt-get upgrade -q -y && \
  apt-get install -y --no-install-recommends golang-1.9 git make gcc libc-dev ca-certificates && \
  git clone --depth 1 --branch release/1.8 https://github.com/ethereum/go-ethereum && \
  (cd go-ethereum && make all) && \
  cp go-ethereum/build/bin/geth geth && \
  cp go-ethereum/build/bin/bootnode bootnode && \
  apt-get remove -y golang-1.9 git make gcc libc-dev && apt autoremove -y && apt-get clean && \
  rm -rf /go-ethereum

RUN mkdir -p /scripts 
RUN mkdir -p /etherdata/dd/geth
RUN mkdir -p /etherdata/account

COPY ./genesis.json /etherdata/genesis.json
# It doesn't matter where the genesis file is, we pass it's path to Geth

COPY ./static-nodes.json /etherdata/dd/geth/static-nodes.json
# For the static nodes file, it has to be in <datadir>/geth because it's read automatically from that path

COPY ./geth1/nodekey /etherdata/dd/geth/nodekey
# Private key used by the Ethereum node to create it's Enode address. The Enode contains it's public address, which is the pair of the private address in nodekey

COPY ./geth1/account/privatekey /etherdata/account/privatekey
# 
COPY ./geth1/account/password /etherdata/account/password

COPY ./start_geth_node.sh /scripts/start_geth_node.sh
RUN chmod +x /scripts/start_geth_node.sh

# These exposes are documentation only, they don't do anything. In the docker-compose.yml file the ports are actually hooked up.
EXPOSE 8545
# RPC communication over HTTP, used to reach the node locally via web3, Truffle etc

EXPOSE 30303
# Node discovery and communication port. Through this port it with other nodes in the network

ENTRYPOINT ["/scripts/start_geth_node.sh"]
# First command to be executed in the container