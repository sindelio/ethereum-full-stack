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
COPY ./static-nodes.json /etherdata/dd/geth/static-nodes.json

COPY ./nodekey /etherdata/dd/geth/nodekey
COPY ./account/privatekey /etherdata/account/privatekey
COPY ./account/password /etherdata/account/password

COPY ./start_geth_node.sh /scripts/start_geth_node.sh
RUN chmod +x /scripts/start_geth_node.sh

EXPOSE 8545
EXPOSE 30303
# These exposes are documentation only, they don't do anything

ENTRYPOINT ["/scripts/start_geth_node.sh"]