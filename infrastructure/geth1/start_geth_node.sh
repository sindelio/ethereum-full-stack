#!/bin/bash

set -u
set -e

if [ ! -d /etherdata/dd/geth/chaindata ]; then
	echo "[*] Mining Genesis block"
	/geth --datadir /etherdata/dd init /etherdata/genesis.json
fi

if [ ! "$(ls -A /etherdata/dd/keystore)"  ]; then
	echo "[*] Importing node account"
	/geth account import --datadir /etherdata/dd --password /etherdata/account/password	/etherdata/account/privatekey
fi

# echo "[*] Setting node as a bootnode"
# echo "enode://$enode@127.0.0.1:30303?discport=0" > /etherdata/dd/geth/static-nodes.json
./bootnode -nodekey /etherdata/dd/geth/nodekey -writeaddress

echo "[*] Starting Geth node"
GETH_ARGS="--datadir /etherdata/dd --networkid=99 --syncmode full --port 30303 --rpc --rpcaddr 0.0.0.0 --rpcport 8545 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3 --ws --wsorigins="*" --wsaddr 0.0.0.0 --wsport 8546 --wsapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3 --nodiscover --mine --miner.threads 1 --miner.etherbase 0x0000000000000000000000000000000000000000 --unlock 0 --password etherdata/account/password"
/geth $GETH_ARGS
# --bootnodes enode://fde9c19114858cc14d6373956667675eb6dc6ed7b6c5cbd7a77bc04bd2e5fa471cb755fce32fede277ef79df83b87477d67faac08b30bc39112024207fa26218@172.13.0.2:30303?discport=0