#!/bin/bash

if [ -v MOUNT_DEVICE ]; then
    for device in $(echo $MOUNT_DEVICE); do

        dev=$(echo $device | cut -d":" -f1)
        mnt=$(echo $device | cut -d":" -f2)
        type=$(echo $device | cut -d":" -f3)
        opts=$(echo $device | cut -d":" -f4)
        dump=$(echo $device | cut -d":" -f5)
        pass=$(echo $device | cut -d":" -f6)

        type=${type:-auto}
        opts=${opts:-defaults}
        dump=${dump:-0}
        pass=${pass:-1}

        if ! grep -qs "^${dev} " ${ROOTFS_DIR}/etc/fstab; then
            mkdir -p ${ROOTFS_DIR}/${mnt}
            printf "%-21s %-15s %-7s %-11s %-8s %s" \
                ${dev} ${mnt} ${type} ${opts} ${dump} ${pass} \
                >> ${ROOTFS_DIR}/etc/fstab
            cat ${ROOTFS_DIR}/etc/fstab
        fi
    done
fi
