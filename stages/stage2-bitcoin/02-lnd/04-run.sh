#!/bin/bash -e

local_clean()
{
    echo "clean"
    rm -rf lnd-linux-armv7-*
    rm -rf manifest*
}

if [ -v LND_ALIAS ] && [ -v LND_COLOR ]; then

local_clean

# Download sources
wget -nv https://github.com/lightningnetwork/lnd/releases/download/v${LND_VERSION}/lnd-linux-armv7-v${LND_VERSION}.tar.gz
wget -nv https://github.com/lightningnetwork/lnd/releases/download/v${LND_VERSION}/manifest-v${LND_VERSION}.txt.sig
wget -nv https://github.com/lightningnetwork/lnd/releases/download/v${LND_VERSION}/manifest-v${LND_VERSION}.txt

# Verify release
curl https://keybase.io/bitconner/pgp_keys.asc | gpg --import
gpg --verify manifest-v${LND_VERSION}.txt.sig
cat manifest-v${LND_VERSION}.txt | grep lnd-linux-armv7 > manifest.stripped
sha256sum -c manifest.stripped

# extract source
tar -xvf lnd-linux-armv7-v${LND_VERSION}.tar.gz

# Install lnd bins
install -m 0755 -t ${ROOTFS_DIR}/usr/local/bin/ lnd-linux-armv7-v${LND_VERSION}/*

# Install and patch config file
mkdir -p ${ROOTFS_DIR}/home/bitcoin/.lnd
install -m 0755 -t ${ROOTFS_DIR}/home/bitcoin/.lnd files/lnd.conf
sed -i "s/alias=/alias=${LND_ALIAS}/g" \
    ${ROOTFS_DIR}/home/bitcoin/.lnd/lnd.conf
sed -i "s/color=/color=${LND_COLOR}/g" \
    ${ROOTFS_DIR}/home/bitcoin/.lnd/lnd.conf
sed -i "s/bitcoind.rpcuser=/bitcoind.rpcuser=${BITCOIN_RPC_USER}/g" \
    ${ROOTFS_DIR}/home/bitcoin/.lnd/lnd.conf
sed -i "s/bitcoind.rpcpass=/bitcoind.rpcpass=${BITCOIN_RPC_PASSWORD}/g" \
    ${ROOTFS_DIR}/home/bitcoin/.lnd/lnd.conf

# install service configuration
install -m 0644 -t ${ROOTFS_DIR}/etc/systemd/system/ files/lnd.service
on_chroot << EOF
    systemctl enable lnd.service
    chown -R bitcoin:bitcoin /home/bitcoin/.lnd

EOF

fi

local_clean
