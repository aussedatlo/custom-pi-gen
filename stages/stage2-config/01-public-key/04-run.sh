#!/bin/bash -e

if [ -v PUBLIC_KEY_PATH ]; then
    log "installing $PUBLIC_KEY_PATH"
    mkdir -p ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.ssh
    cat $PUBLIC_KEY_PATH > "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.ssh/authorized_keys"
else
    log "no public key installed"
fi
