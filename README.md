# AlignedLayer

## Prequisites

* CPU: 4 cores
* Memory: 16GB
* Disk: 160GB

I am using hetzner cloud CX41 instance for this setup. You can use my [referral link](https://hetzner.cloud/?ref=3Q6Q6Q6Q6Q6Q) if you want.

## Installation 

Down the script and make it executable, then run it with your moniker. You might create a screen session to run the script as it takes a while.

```bash
curl -OJL https://raw.githubusercontent.com/bdehri/alignedlayer-guide/main/alignedlayer.sh
chmod +x alignedlayer.sh
./alignedlayer.sh <moniker>
```

After script is finished, you need create your keys.

```bash
export PATH=$PATH:/root/go/bin
alignedlayerd keys add <AccountName>
```

After you have created your keys, you need to get some tokens to your account from the [faucet](https://faucet.alignedlayer.com/). You can get nearly 11 tokens on multiple tries.

Lastly, you need to create your validator after your node is synced. You can check the status with the following command. If the `catching_up` is `false`, you can create your validator.

```bash
alignedlayerd status | jq .sync_info.catching_up
```


You can create your validator with the following command. Example command stakes 10.5 tokens.

```bash
cd ~/aligned_layer_tendermint
bash setup_validator.sh <AccountName> 10500000stake
```