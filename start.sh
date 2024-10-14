EXT_IP=$(sed -n 's/EXT_IP: \(.*\)/\1/p' config.yml)
VALIDATOR_MNEMONIC=$(sed -n 's/VALIDATOR_MNEMONIC: \(.*\)/\1/p' config.yml)
VALIDATOR_WITHDRAW_ADDRESS=$(sed -n 's/VALIDATOR_WITHDRAW_ADDRESS: \(.*\)/\1/p' config.yml)
VALIDATOR_MINER_FEE_ADDRESS=$(sed -n 's/VALIDATOR_MINER_FEE_ADDRESS: \(.*\)/\1/p' config.yml)
sed -i 's|https://testwalletapi.orex.work/api/common/v1/ping|https://testwalletapi.orex.work/api/common/v1/ping|g' consensus-docker/resources/start_validator.sh


echo "EXT_IP: $EXT_IP"
echo "VALIDATOR_MNEMONIC: $VALIDATOR_MNEMONIC"
echo "VALIDATOR_WITHDRAW_ADDRESS: $VALIDATOR_WITHDRAW_ADDRESS"
echo "VALIDATOR_MINER_FEE_ADDRESS: $VALIDATOR_MINER_FEE_ADDRESS"

sed -i "s/EXTIP: \"[^\"]*\"/EXTIP: \"$EXT_IP\"/" docker-compose.yml
sed -i "s/FEE_RECIPIENT: \"[^\"]*\"/FEE_RECIPIENT: \"$VALIDATOR_MINER_FEE_ADDRESS\"/" docker-compose.yml
sed -i "s/HOST_IP: [^ ]*/HOST_IP: $EXT_IP/" docker-compose.yml
sed -i 's/PEER_IP_LIST: "[^"]*"/PEER_IP_LIST: "13.250.64.220,52.76.172.102,13.250.98.136"/' docker-compose.yml

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

