#!/bin/bash

# turn on bash's job control
set -m

mkdir /config
mkdir -p /data/cache
chown named:named /data/cache
chmod 755 /data/cache
    
echo "Git clone ${GITHUB_CONFIG_REPO} in ${GITHUB_CLONE_DIR}"
git clone ${GITHUB_CONFIG_REPO} ${GITHUB_CLONE_DIR}

echo "kopie naar config"
cp -frp ${GITHUB_CLONE_DIR}/dns/* /config
sed s/#LISTEN_ON#/${LISTEN_ON}/g /config/named.conf -i

chown -R named:named /config
chmod -R 755 /config

/usr/sbin/named -g -c /config/named.conf -u named &

# now we bring the primary process back into the foreground
# and leave it there
fg %1
