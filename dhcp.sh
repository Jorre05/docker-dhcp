#!/bin/bash

# turn on bash's job control
set -m

if [ -d /${GITHUB_CLONE_DIR} ]; then
    echo "Verwijderen "${GITHUB_CLONE_DIR}
    rm -fr ${GITHUB_CLONE_DIR}
fi

echo "Aanmaken git map "${GITHUB_CLONE_DIR}
mkdir -p /${GITHUB_CLONE_DIR}
git clone ${GITHUB_CONFIG_REPO} ${GITHUB_CLONE_DIR}
    
if [ ! -d /config ]; then
    echo "Aanmaken config map "
    mkdir -p /config
fi

if [ ! -f /config/kea-dhcp4.conf ]; then
    echo "kopie naar config"
    cp -frp ${GITHUB_CLONE_DIR}/dhcp/kea-dhcp4.conf /config
    sed "s/#LISTEN_ON#/${LISTEN_ON}/g" /config/kea-dhcp4.conf -i
    sed "s/#DNS_SERVERS#/${DNS_SERVERS}/g" /config/kea-dhcp4.conf -i
fi

if [ ! -f /config/kea-dhcp-ddns.conf ]; then
    echo "kopie naar config"
    cp -frp ${GITHUB_CLONE_DIR}/dhcp/kea-dhcp-ddns.conf /config
fi

mkdir -p /run/kea
rm -fr /run/kea/kea*

/usr/sbin/kea-dhcp4 -c /config/kea-dhcp4.conf &
/usr/sbin/kea-dhcp-ddns -c /config/kea-dhcp-ddns.conf &

fg %1
