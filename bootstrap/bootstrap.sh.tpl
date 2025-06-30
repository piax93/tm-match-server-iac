#!/bin/bash

set -x -e

# docker/tools install
apt update
apt install -y docker.io docker-compose-v2 curl unzip

# fetch docker-compose setup
cd /root
curl -sSLf -o iac.zip https://github.com/piax93/tm-match-server-iac/archive/refs/heads/main.zip
unzip iac.zip
cd tm-*/server

# set all needed env vars
export TM_MASTERSERVER_LOGIN='${dedi_login}'
export TM_MASTERSERVER_PASSWORD='${dedi_password}'
export TM_SERVER_PASSWORD='${room_password}'
export TM_SYSTEM_FORCE_IP_ADDRESS=$(curl -s https://ipinfo.io/ip)
export MANIACONTROL_DB_HOST='${db_host}'
export MANIACONTROL_DB_NAME='${db_name}'
export MANIACONTROL_DB_USER='${db_user}'
export MANIACONTROL_DB_PASSWORD='${db_password}'
export MANIACONTROL_ADMINS='${join(":", admins)}'

# update match settings with tracks
%{ for name, url in maps }
echo '<map><file>Downloaded/${name}.Map.Gbx</file></map>' >> trackmania/maplist.txt
%{ endfor ~}
echo '</playlist>' >> trackmania/maplist.txt

# start server
docker compose up --build -d

# download tracks in userdata volume
cd /var/lib/docker/volumes/*_userdata/_data/Maps/
mkdir -p Downloaded
%{ for name, url in maps }
curl -sSLf -o 'Downloaded/${name}.Map.Gbx' '${url}'
%{ endfor ~}
