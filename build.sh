#!/bin/bash

# stage2-config
export ENABLE_WIFI="${ENABLE_WIFI:-0}"
export PUBLIC_KEY_PATH
export MOUNT_DEVICE

# stage2-nextcloud
export NEXTCLOUD_DB_USER="${NEXTCLOUD_DB_USER:-nextcloud}"
export NEXTCLOUD_DB_NAME="${NEXTCLOUD_DB_USER:-nextcloud}"
export NEXTCLOUD_DB_PASSWD="${NEXTCLOUD_DB_USER:-nextcloudpasswd}"

# stage2-bitcoin
export BITCOIN_VERSION="${BITCOIN_VERSION:-0.20.1}"
export BITCOIN_DATA_DIR="${BITCOIN_DATA_DIR:-/home/bitcoin}"
export BITCOIN_RPC_USER
export BITCOIN_RPC_PASSWORD

export LND_VERSION="${LND_VERSION:-0.11.1-beta}"
export LND_ALIAS
export LND_COLOR

source ./pi-gen/build.sh
