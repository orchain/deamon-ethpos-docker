pubkey=$(grep '"pubkey"' basicconfig/validator_keys/deposit_data.json | sed -E 's/.*"pubkey": "([^"]+)".*/\1/')
echo "Your public key is: $pubkey"
