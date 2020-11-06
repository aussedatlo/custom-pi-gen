# custom-pi-gen

This project add a complementary layer to [pi-gen](https://github.com/RPi-Distro/Pi-gen)
project to create Raspberry Pi OS images.

## Create distribution

Edit `config` file with your configuration, then run :

```bash
sudo ./build.sh
```

## Config

Configuration for custom-pi-gen is the same as pi-gen with additional parameters.
For classic configuration of pi-gen, check [pi-gen readme](pi-gen/README.md).
For custom-pi-gen configuration, check information below.

Create `STAGE_LIST` variable with the required stages. For example

```bash
STAGE_LIST="pi-gen/stage0 pi-gen/stage1 pi-gen/stage2 stages/stage2-config"
```

> without this line, no stages will be found.

## List of custom stages

### stage2-config

This stage install basic configuration.

|Parameters|Description|
|----------|-----------|
|PUBLIC_KEY_PATH|Path to the public key to install in user .shh folder|
|ENABLE_WIFI|Activate wifi on startup (default 0)|

### stage2-nextcloud

This stage install nextcloud

|Parameters|Description|
|----------|-----------|
|NEXTCLOUD_DB_USER|nextcloud database user (default nextcloud)|
|NEXTCLOUD_DB_NAME|nextcloud database name (default nextcloud)|
|NEXTCLOUD_DB_PASSWD|nextcloud database password (default nextcloudpasswd)|
