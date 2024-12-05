#!/bin/bash
set -e

validator --wallet-dir=${CONFIG_BASE_DIR}/validator \
--wallet-password-file=/wallet_password \
--suggested-fee-recipient=${FEE_RECIPIENT} \
--chain-config-file=/config.yml \
--config-file=/config.yml \
--beacon-rpc-provider=127.0.0.1:4000 \
--accept-terms-of-use=true \
--heart-url=heart_replace_url \
--heart-second=300
