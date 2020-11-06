#!/bin/bash -e

if [ "${ENABLE_WIFI}" == "1" ]; then
    log "activate wifi on startup"
    install -m 755 files/enable_wifi_once	"${ROOTFS_DIR}/etc/init.d/"

    on_chroot << EOF
    systemctl enable enable_wifi_once
EOF
fi
