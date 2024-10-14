#!/bin/bash
set -e

echo "geth starting "
cp /etc/jwtsecret   ${CONFIG_BASE_DIR}
echo "PEER_IP_LIST=$PEER_IP_LIST"
if [ ! -f "/etc/config.toml" ];then
    cp /etc/config.tmp /etc/config.tmp.1
    PORT=8545
    TIMEOUT=1
    NODE_URL_LIST=""
    echo "process PEER_IP_LIST=$PEER_IP_LIST"
    for IP in $(echo "$PEER_IP_LIST" | tr "," "\n")
    do
      set +e
      nc -z -w $TIMEOUT $IP $PORT &> /dev/null
      result=$?
      if [ $result -eq 0 ]; then
        echo $IP $PORT
        NODE_URL=$(curl -X POST "http://$IP:$PORT" --header 'Content-Type: application/json' --data-raw '{"jsonrpc": "2.0","method": "admin_nodeInfo","params": [],"id": 0}' | jq -r .result.enode)
        echo "*******************************NODE_URL********************=" ${NODE_URL};
        if [ -z "$NODE_URL" ]
        then
          echo "\$NODE_URL is empty"
        else
          echo "\$NODE_URL is NOT empty"
          NODE_URL_LIST+="\"$NODE_URL\","
        fi
      fi
      set -e
    done
    NODE_URL_LIST=${NODE_URL_LIST%,}
    echo $NODE_URL_LIST
    sed -i 's!NODE_URL!'"${NODE_URL_LIST}"'!g' /etc/config.tmp.1;
    mv /etc/config.tmp.1 /etc/config.toml;
fi


geth  --datadir ${DATA_DIR} --http --http.api=net,web3,eth,debug,engine,admin \
                     --http.corsdomain=* --http.vhosts=* --http.addr=0.0.0.0   \
                     --syncmode=full --networkid=97823 --nodiscover \
                     --config=/etc/config.toml \
                     --authrpc.jwtsecret=${CONFIG_BASE_DIR}/jwtsecret --authrpc.addr=0.0.0.0 --authrpc.port=8551 --authrpc.vhosts=* \
                     --verbosity=4 --ipcpath=/data-ephemera --nodekey=${CONFIG_BASE_DIR}/enode.key --nat=extip:${EXTIP}

echo "geth starting endding "
