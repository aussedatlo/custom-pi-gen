#!/bin/bash

# stage2-config
export ENABLE_WIFI="${ENABLE_WIFI:-0}"
export PUBLIC_KEY_PATH

# stage2-nextcloud
export NEXTCLOUD_DB_USER="${NEXTCLOUD_DB_USER:-nextcloud}"
export NEXTCLOUD_DB_NAME="${NEXTCLOUD_DB_USER:-nextcloud}"
export NEXTCLOUD_DB_PASSWD="${NEXTCLOUD_DB_USER:-nextcloudpasswd}"

source ./pi-gen/build.sh
