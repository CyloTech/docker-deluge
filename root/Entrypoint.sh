#!/usr/bin/env sh

set -x

mkdir -p /torrents/downloading
mkdir -p /torrents/completed
mkdir -p /torrents/config/deluge
mkdir -p /torrents/config/deluge/plugins
mkdir -p /torrents/config/log
mkdir -p /torrents/config/torrents
mkdir -p /torrents/config/watch

mv /configs/* /torrents/config/deluge/
rm -fr /configs

chown -R 1000:1000 /torrents

chmod +x /deluge-pass.py
/deluge-pass.py /torrents/config/deluge ${DELUGE_PASSWORD}

cat /torrents/config/deluge/auth | grep "${DELUGE_USERNAME}" || echo "${DELUGE_USERNAME}:${DELUGE_PASSWORD}:10" >> /torrents/config/deluge/auth

exec "/init"