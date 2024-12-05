### Step1 open TCP/UDP port
  - 8551:8551                        eth  authenticated API
  - 8545:8545                        eth http 
  - 30303:30303 udp/tcp              eth p2p
  - 3500:3500                        beacon's http 
  - 8080:8080                        metrics
  - 13000:13000                      p2p 
  - 12000:12000  udp/tcp             p2p listening
  - 6060:6060                        pprof 
  - 7070:7070                        pprof http 

### Step2 build code
```shell
cd /opt
git clone https://github.com/orchain/deamon-ethpos-docker.git
cd deamon-ethpos-docker
chmod +x start.sh
chmod +x clean.sh
``` 
```html
### auto startup
 1 update config.yml EXTIP
 2 update config.yml validator mnemonic
 3 update config.yml validator withdraw address (it can be reset when you use app to deposit)
 4 update config.yml validator miner fee address
 5 execution start.sh // chmod +x start.sh
 6 execution get_public_key.sh // chmod +x get_public_key.sh
--------------------------------------------------------------------------------------
```

###  create validator keys
###### 1 replace your mnemonic
###### 2 replace your keystore_password. you can build a random mnemonic
```shell 
 docker-compose run staking-cli --language=English --non_interactive new-mnemonic --keystore_password=12345678 --chain="mainnet" --num_validators=3 --execution_address=0xCBf79Ae1b1b58Eb6b84Ad159588d35A71dE49b6c
```
```shell
echo "" | docker-compose run  staking-cli \
--language=English \
--non_interactive \
existing-mnemonic \
--folder /basicconfig/ \
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

### run deposit balance
```shell
docker-compose run contract-cli ethereal beacon deposit  --allow-unknown-contract="true" \
--allow-excessive-deposit="true" \
--address="0x3e839677d23d9b7b0df00ed0c67750aa6412b75d" \
--connection=http://localhost:8545/  \
--data="/basicconfig/validator_keys/deposit_data.json"  \
--from="replace" \
--privatekey="replace" \
--max-fee-per-gas=51000000000000 \
--priority-fee-per-gas="5100 gwei"
```
or powershell
```shell
docker-compose run contract-cli ethereal beacon deposit  --allow-unknown-contract="true" --allow-excessive-deposit="true" --address="0x3e839677d23d9b7b0df00ed0c67750aa6412b75d" --connection=http://localhost:8545/ --data="/basicconfig/validator_keys/deposit_data.json" --value="1024" --from="replace" --privatekey="replace" --max-fee-per-gas=5100000000000
```
