EXT_IP=$(sed -n 's/EXT_IP: \(.*\)/\1/p' config.yml)
VALIDATOR_MNEMONIC=$(sed -n 's/VALIDATOR_MNEMONIC: \(.*\)/\1/p' config.yml)
VALIDATOR_WITHDRAW_ADDRESS=$(sed -n 's/VALIDATOR_WITHDRAW_ADDRESS: \(.*\)/\1/p' config.yml)
VALIDATOR_MINER_FEE_ADDRESS=$(sed -n 's/VALIDATOR_MINER_FEE_ADDRESS: \(.*\)/\1/p' config.yml)
HEART_BEAT=$(sed -n 's/HEART_BEAT: \(.*\)/\1/p' config.yml)
PEER_IP_LIST=$(sed -n 's/PEER_IP_LIST: \(.*\)/\1/p' config.yml)
GENESIS_JSON=$(sed -n 's/GENESIS_JSON: \(.*\)/\1/p' config.yml)
GENESIS_SSZ=$(sed -n 's/GENESIS_SSZ: \(.*\)/\1/p' config.yml)


echo "EXT_IP: $EXT_IP"
echo "VALIDATOR_MNEMONIC: $VALIDATOR_MNEMONIC"
echo "VALIDATOR_WITHDRAW_ADDRESS: $VALIDATOR_WITHDRAW_ADDRESS"
echo "VALIDATOR_MINER_FEE_ADDRESS: $VALIDATOR_MINER_FEE_ADDRESS"

sed -i "s/EXTIP: \"[^\"]*\"/EXTIP: \"$EXT_IP\"/" docker-compose.yml
sed -i "s/FEE_RECIPIENT: \"[^\"]*\"/FEE_RECIPIENT: \"$VALIDATOR_MINER_FEE_ADDRESS\"/" docker-compose.yml
sed -i "s/HOST_IP: [^ ]*/HOST_IP: $EXT_IP/" docker-compose.yml
sed -i "s/PEER_IP_LIST: [^]*/PEER_IP_LIST: $PEER_IP_LIST/" docker-compose.yml
sed -i "s|https://testwalletapi.orex.work/api/common/v1/ping|$HEART_BEAT|g" consensus-docker/resources/start_validator.sh
sed -i "s|https://raw.githubusercontent.com/orchain/genesis-ethpos-docker/main/public/genesis.json|$GENESIS_JSON|g" execution-docker-base/resources/eth_init.sh
sed -i "s|https://raw.githubusercontent.com/orchain/genesis-ethpos-docker/main/public/genesis.ssz|$GENESIS_SSZ|g" consensus-docker/resources/start_beacon.sh

sleep 10s


docker-compose build --no-cache

echo "" | docker-compose run  staking-cli \
--language=English \
--non_interactive \
existing-mnemonic \
--folder /basicconfig \
--mnemonic="$VALIDATOR_MNEMONIC" \
--keystore_password=12345678 \
--chain="mainnet" \
--validator_start_index=0 \
--num_validators=1 \
--execution_address="$VALIDATOR_WITHDRAW_ADDRESS" \
--devnet_chain_setting=/config_deposit.yml

echo "" | docker-compose run beaconbase validator_init.sh
echo "" | docker-compose run ethbase eth_init.sh
echo "" | docker-compose up -d eth
echo "" | docker-compose up -d beacon

pubkey=$(grep '"pubkey"' basicconfig/validator_keys/deposit_data.json | sed -E 's/.*"pubkey": "([^"]+)".*/\1/')
echo "Your public key is: $pubkey"

