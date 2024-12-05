json_file="basicconfig/validator_keys/deposit_data.json"
if [[ ! -f $json_file ]]; then
  echo "JSON  $json_file ！"
  exit 1
fi
grep -o '"pubkey": "[^"]*"' "$json_file" | awk -F': ' '{print $2}' | tr -d '"'