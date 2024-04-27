#!/bin/bash

set -e
if [ $# -lt 1 ]; then
    echo "Kullanım: $0 <moniker>"
    exit 1
else
    MONIKER=$1
fi

apt update -y
apt install build-essential libc6 jq git -y

# Check if Go is installed
if ! command -v go &> /dev/null
then
    echo "Go is not installed. Installing..."
    echo "Downloading Go..."
    wget https://go.dev/dl/go1.22.2.linux-amd64.tar.gz
    tar -C /usr/local -xzf go1.22.2.linux-amd64.tar.gz
    echo 'export PATH=$PATH:/usr/local/go/bin:/root/go/bin' >> /root/.bashrc
    export PATH=$PATH:/usr/local/go/bin:/root/go/bin
    echo "Go is installed."
else
    echo "Go is already installed."
fi

echo "Installing rust"
curl https://sh.rustup.rs -sSf | sh -s -- -y
. $HOME/.cargo/env
echo "Rust is installed"

echo "Installing Ignite CLI"
curl https://get.ignite.com/cli! | bash
echo "Ignite CLI is installed"


rm -rf aligned_layer_tendermint
git clone https://github.com/yetanotherco/aligned_layer_tendermint.git
cd aligned_layer_tendermint
make build-linux

bash setup_node.sh $MONIKER

cat <<EOF | sudo tee /etc/systemd/system/alignedlayer.service > /dev/null
[Unit]
Description=alignedlayer Daemon
After=network-online.target

[Service]
User=root
ExecStart=/root/go/bin/alignedlayerd start
Restart=always
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

systemctl enable alignedlayer 
systemctl start alignedlayer
