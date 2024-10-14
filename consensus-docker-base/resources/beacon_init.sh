#!/bin/bash
set -e
echo "beancon init startting"
prysmctl testnet generate-genesis --num-validators=3 --deposit-json-file=/basicconfig/validator_keys/deposit_data.json \
           --output-ssz=/basicconfig/genesis.ssz --chain-config-file=/config.yml --geth-genesis-json-in=/genesis.json \
           --geth-genesis-json-out=/basicconfig/genesis.json --fork=capella

echo "beancon init end..."
