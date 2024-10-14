#!/bin/bash
set -e
echo "beacon starting " ;
wget -P ${CONFIG_BASE_DIR} https://raw.githubusercontent.com/dachengcheng2022/genesis-ethpos-docker/release/public/genesis.ssz ;

TIMEOUT=1
PORT=3500
OPEN_PEER_LIST=""
for IP in $(echo "$PEER_IP_LIST" | tr "," "\n")
do
  set +e
  nc -z -w $TIMEOUT "$IP" "$PORT" &> /dev/null
  result=$?
  if [ $result -eq 0 ]; then
    PEER_INFO=$(curl -X GET "http://$IP:$PORT/eth/v1/node/identity" --header 'Content-Type: application/json'| jq -r .data.enr) ;
    OPEN_PEER_LIST+="$PEER_INFO,"
  fi
  set -e
done
OPEN_PEER_LIST=${OPEN_PEER_LIST%,}
#PEER_INFO2=$(curl -X GET 'http://47.236.70.198:3500/eth/v1/node/identity' --header 'Content-Type: application/json'| jq -r .data.p2p_addresses[2]) ;
#PEER_INFO3=$(curl -X GET 'http://8.219.234.134:3500/eth/v1/node/identity' --header 'Content-Type: application/json'| jq -r .data.p2p_addresses[2]) ;
PEER_INFO=$OPEN_PEER_LIST
echo "PEER_INFO=" ${PEER_INFO} ;
beacon-chain \
  --datadir=${DATA_DIR} \
  --min-sync-peers=0 \
  --genesis-state=${CONFIG_BASE_DIR}/genesis.ssz \
  --chain-config-file=/config.yml \
  --config-file=/config.yml \
  --chain-id=97823 \
  --rpc-host=0.0.0.0 \
  --contract-deployment-block=0 \
  --grpc-gateway-host=0.0.0.0 \
  --monitoring-host=0.0.0.0 \
  --execution-endpoint=http://eth:8551 \
  --accept-terms-of-use \
  --jwt-secret=${CONFIG_BASE_DIR}/jwtsecret \
  --contract-deployment-block=0 \
  --verbosity=info \
  --p2p-local-ip=0.0.0.0 \
  --p2p-host-ip=${HOST_IP} \
  --p2p-static-id  \
  --peer=${PEER_INFO} \
  --pprof \
  --pprofaddr=0.0.0.0

echo "beacon starting endding "


