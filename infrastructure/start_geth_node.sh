#!/bin/bash

set -u
set -e

if [ ! -d /etherdata/dd/geth/chaindata ]; then
	echo "[*] Mining Genesis block"
	/geth --datadir /etherdata/dd init /etherdata/genesis.json
	# As mentioned, it doesn't matter where the genesis file is since we specify it's path here. it only creates the genesis block if there's no chain information yet.
fi

if [ ! "$(ls -A /etherdata/dd/keystore)" ]; then
	echo "[*] Importing node account"
	/geth account import --datadir /etherdata/dd --password /etherdata/account/password	/etherdata/account/privatekey
	# Import node account if it doesn't exist yet. the import creates an account file inside /etherdata/dd/keystore
fi

echo "[*] Setting node as a bootnode"
./bootnode -nodekey /etherdata/dd/geth/nodekey -writeaddress
# This command is vital to make the node a bootnode. That means this node will hold a "canonical chain", which is trusted by other nodes as the true chain.
# The -writeaddress option makes the node write it's public address in the network and continue listening in the background. this is vital because we don't want the node to be just a bootnode, but also a full fledged node, so we have to execute other commands in it's shell.

echo "[*] Starting Geth node"
GETH_ARGS="--datadir /etherdata/dd --networkid=99 --syncmode full --port 30303 --rpc --rpcaddr 0.0.0.0 --rpcport 8545 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3 --ws --wsorigins="*" --wsaddr 0.0.0.0 --wsport 8546 --wsapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3 --nodiscover --mine --miner.threads 1 --miner.etherbase 0x0000000000000000000000000000000000000000 --unlock 0 --password etherdata/account/password"
/geth $GETH_ARGS
# Instead of using a static-nodes.json file, we could also specify the bootnodes with the --bootnodes flag and list their Enodes.
# Options:
# --syncmode full
# Vital option to make the network work in POA consensus and avoid the bad propagation block error.
#  --unlock 0 --password /path/to/file
#  Vital to unlock the account that will receive the incentives for mining.
# --nodiscover
# Vital to keep the network private, without any external nodes
# --rpc --rpcaddr 0.0.0.0 --rpcport 8545 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3
# Vital to allow local connections to the node, via RPC over HTTP. This allows us to use web3 to issue programatic commands to the node.
# --ws --wsorigins="*" --wsaddr 0.0.0.0 --wsport 8546 --wsapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3
#  Same thing for RPC over Web Sockets. This is particularly important to use  event communication between the node and a client app.
# --networkid=99
# Custom network id, can be anything. It doesn't really matter in a private network, but it would matter in an open network which other nodes can connect to.
