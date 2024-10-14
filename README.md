### 0 clone code
```shell
cd /opt
git clone https://github.com/dachengcheng2022/deamon-ethpos-docker.git
cd deamon-ethpos-docker
git checkout release
```
### auto startup
### 1 update config.yml EXTIP
### 2 update config.yml validator mnemonic
### 3 update config.yml validator withdraw address
### 4 update config.yml validator miner fee address
### 5 execution start.sh

--------------------------------------------------------------------------------------
### manual startup
### 1 docker build 
###### 1.1 before build need modify /consensus-docker-base directory account_password and wallet_password's password. it the same as 2.2 keystore_password params
###### 1.2 ##change docker-compose.yml  eth and beacon expose IP###
```shell
sed -i 's/EXTIP: "[^"]*"/EXTIP: "13.250.64.220"/' docker-compose.yml
sed -i 's/PEER_IP_LIST: "[^"]*"/PEER_IP_LIST: "13.250.64.220,52.76.172.102,13.250.98.136"/' docker-compose.yml
sed -i 's/HOST_IP: [^"]*/HOST_IP: "13.250.64.220"/' docker-compose.yml
```

```shell
docker-compose build --no-cache
```

### 2 create validator keys
###### 2.1 replace your mnemonic
###### 2.2 replace your keystore_password. you can build a random mnemonic
```shell 
 docker-compose run staking-cli --language=English --non_interactive new-mnemonic --keystore_password=12345678 --chain="mainnet" --num_validators=3 --execution_address=0xCBf79Ae1b1b58Eb6b84Ad159588d35A71dE49b6c
```
```shell
echo "" | docker-compose run  staking-cli \
--language=English \
--non_interactive \
existing-mnemonic \
--folder /basicconfig/test \
--mnemonic="sniff goose latin finish gadget dentist theme wet that nut border glad funny february bean net loud sign practice off rigid razor icon game" \
--keystore_password=12345678 \
--chain="mainnet" \
--validator_start_index=0 \
--num_validators=3 \
--execution_address=0xCBf79Ae1b1b58Eb6b84Ad159588d35A71dE49b6c \
--devnet_chain_setting=/config_deposit.yml
```
or powershell 
```shell
docker-compose run staking-cli --language=English --non_interactive existing-mnemonic --folder /basicconfig --mnemonic="sniff goose latin finish gadget dentist theme wet that nut border glad funny february bean net loud sign practice off rigid razor icon game" --keystore_password=12345678 --chain="mainnet" --validator_start_index=0 --num_validators=3 --execution_address=0xCBf79Ae1b1b58Eb6b84Ad159588d35A71dE49b6c --devnet_chain_setting=/config_deposit.yml
```
### 2 validator init 
```shell
docker-compose run beaconbase validator_init.sh
```

### 3 geth init 
```shell
docker-compose run ethbase eth_init.sh
```

### 4 run geth
```shell
docker-compose up -d eth
```

### 5 run beacon and validator
```shell
docker-compose up -d beacon
```

### 7 run deposit balance
```shell
docker-compose run contract-cli ethereal beacon deposit  --allow-unknown-contract="true" \
--allow-excessive-deposit="true" \
--address="0x3e839677d23d9b7b0df00ed0c67750aa6412b75d" \
--connection=http://52.76.172.102:8545/  \
--data="/basicconfig/validator_keys/deposit_data.json"  \
--from="0x943fA1E47Df2759244A85cDb49370F5f5812D74D" \
--privatekey="0x19d69973a1fc35ae1265f0977c7de7bedfc74d5061076c8caa11ea5c9a01e909"
```
or powershell
```shell
docker-compose run contract-cli ethereal beacon deposit  --allow-unknown-contract="true" --allow-excessive-deposit="true" --address="0x3e839677d23d9b7b0df00ed0c67750aa6412b75d" --connection=http://190.92.198.117:8545/ --data="/basicconfig/validator_keys/deposit_data.json" --value="1024" --from="0x123463a4B065722E99115D6c222f267d9cABb524" --privatekey="2e0834786285daccd064ca17f1654f67b4aef298acbb82cef9ec422fb4975622" --max-fee-per-gas=5100000000000
```