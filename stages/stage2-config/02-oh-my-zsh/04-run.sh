#!/bin/bash -e

FILE_PATH=$(dirname "$(readlink -f "$BASH_SOURCE")")/file
install -v -m 644 file/zshrc "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.zshrc"
curl -s -L git.io/antigen > "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/antigen.zsh"

on_chroot << EOF
    rm -rf /home/${FIRST_USER_NAME}/.oh-my-zsh

    wget -nv https://github.com/ohmyzsh/ohmyzsh/archive/master.zip
    unzip -q -o -d /home/${FIRST_USER_NAME} master.zip
    rm -rf master.zip

    mv /home/${FIRST_USER_NAME}/ohmyzsh-master /home/${FIRST_USER_NAME}/.oh-my-zsh

    chsh ${FIRST_USER_NAME} -s /usr/bin/zsh
EOF
