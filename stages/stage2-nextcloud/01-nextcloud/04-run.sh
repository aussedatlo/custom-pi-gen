#!/bin/bash -e

# Install nextcloud
on_chroot << EOF
    rm -rf nextcloud*
    rm -rf /var/www/*

    wget -nv https://github.com/nextcloud/server/releases/download/v20.0.1/nextcloud-20.0.1.zip
    mkdir -p /var/www/html/
    unzip -q -o -d /var/www/html/ nextcloud-20.0.1.zip

    rm -rf nextcloud-*
    chmod 750 /var/www/html/nextcloud -R
    chown www-data:www-data /var/www/html/nextcloud -R
EOF

if  [ -v NEXTCLOUD_DB_NAME ] && \
    [ -v NEXTCLOUD_DB_PASSWD ] && \
    [ -v NEXTCLOUD_DB_USER ]; then
    # Create database at startup
    log "install mysql_create_db_once andcreate database at startup"
    install -m 755 file/mysql_create_db_once	"${ROOTFS_DIR}/etc/init.d/"
    sed -i "s/DATABASE_NAME=/DATABASE_NAME=${NEXTCLOUD_DB_NAME}/g" \
        ${ROOTFS_DIR}/etc/init.d/mysql_create_db_once
    sed -i "s/DATABASE_USER=/DATABASE_USER=${NEXTCLOUD_DB_USER}/g" \
        ${ROOTFS_DIR}/etc/init.d/mysql_create_db_once
    sed -i "s/DATABASE_PASSWORD=/DATABASE_PASSWORD=${NEXTCLOUD_DB_PASSWD}/g" \
        ${ROOTFS_DIR}/etc/init.d/mysql_create_db_once
    on_chroot << EOF
    systemctl enable mysql_create_db_once
EOF
else
    log "don't create databaseat startup"
fi
