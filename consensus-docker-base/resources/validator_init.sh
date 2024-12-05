#!/bin/bash
set -e
echo "validator init startting"

validator  accounts import --wallet-dir=/basicconfig/validator   --keys-dir=/basicconfig/validator_keys --wallet-password-file=/wallet_password \
           --account-password-file=/account_password --accept-terms-of-use=true

echo "validator init end..."
