#!/bin/bash
set -e
echo "geth init startting"
wget -P ${CONFIG_BASE_DIR}/ https://raw.githubusercontent.com/orchain/deamon-ethpos-docker/main/public/genesis.json
geth --datadir ${DATA_DIR} init ${CONFIG_BASE_DIR}/genesis.json
bootnode --genkey=${CONFIG_BASE_DIR}/enode.key --writeaddress

echo "geth init end..."
