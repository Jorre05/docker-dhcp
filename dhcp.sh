#!/bin/bash

# turn on bash's job control
set -m

mkdir /config
mkdir -p /run/kea
    
echo "Git clone ${GITHUB_CONFIG_REPO} in ${GITHUB_CLONE_DIR}"
git clone ${GITHUB_CONFIG_REPO} ${GITHUB_CLONE_DIR}

echo "kopie naar config"
cp -frp ${GITHUB_CLONE_DIR}/dhcp/* /config
sed "s/#LISTEN_ON#/${LISTEN_ON}/g" /config/kea-dhcp4.conf -i
sed "s/#DNS_SERVERS#/${DNS_SERVERS}/g" /config/kea-dhcp4.conf -i

/usr/sbin/kea-dhcp4 -c /config/kea-dhcp4.conf &
/usr/sbin/kea-dhcp-ddns -c /config/kea-dhcp-ddns.conf &

# now we bring the primary process back into the foreground
# and leave it there
fg %1
