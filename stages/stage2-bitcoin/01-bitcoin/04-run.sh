#!/bin/bash -e

local_clean()
{
    rm -rf bitcoin-${BITCOIN_VERSION}-arm-linux-gnueabihf.tar.gz*
    rm -rf bitcoin-${BITCOIN_VERSION}*
    rm -rf SHA256SUMS*
}

local_clean

if [ ! -v BITCOIN_RPC_USER ] || [ ! -v BITCOIN_RPC_PASSWORD ]; then
    echo "BITCOIN_RPC_USER and BITCOIN_RPC_PASSWORD required"
    exit 1
fi

# Download and check sources
wget -nv https://bitcoin.org/bin/bitcoin-core-${BITCOIN_VERSION}/bitcoin-${BITCOIN_VERSION}-arm-linux-gnueabihf.tar.gz
wget -nv https://bitcoin.org/bin/bitcoin-core-0.20.1/SHA256SUMS.asc
cat SHA256SUMS.asc | grep arm-linux-gnueabihf > SHA256SUMS.stripped
sha256sum -c SHA256SUMS.stripped
tar -xvf bitcoin-${BITCOIN_VERSION}-arm-linux-gnueabihf.tar.gz

# Install bin
install -m 0755 -t ${ROOTFS_DIR}/usr/local/bin/ bitcoin-${BITCOIN_VERSION}/bin/*

# Install and patch config file
mkdir -p ${ROOTFS_DIR}/home/bitcoin/.bitcoin
install -m 0755 -t ${ROOTFS_DIR}/home/bitcoin/.bitcoin files/bitcoin.conf
sed -i "s/datadir=/datadir=$(echo ${BITCOIN_DATA_DIR}| sed 's/\//\\\//g')/g" \
    ${ROOTFS_DIR}/home/bitcoin/.bitcoin/bitcoin.conf
sed -i "s/rpcuser=/rpcuser=${BITCOIN_RPC_USER}/g" \
    ${ROOTFS_DIR}/home/bitcoin/.bitcoin/bitcoin.conf
sed -i "s/rpcpassword=/rpcpassword=${BITCOIN_RPC_PASSWORD}/g" \
    ${ROOTFS_DIR}/home/bitcoin/.bitcoin/bitcoin.conf

# Install init script
install -m 0644 -t ${ROOTFS_DIR}/etc/systemd/system/ files/bitcoind.service

# Create bitcoin user and enable bitcoind service
on_chroot << EOF
    if ! id -u bitcoin >/dev/null 2>&1; then
        useradd -s /dev/false -d /home/bitcoin/ bitcoin
    fi
    chown -R bitcoin:bitcoin /home/bitcoin
    systemctl enable bitcoind

EOF

local_clean
