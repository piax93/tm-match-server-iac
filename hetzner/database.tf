locals {
  database_name = "maniacontrol"
  database_user = "maniacontrol"
  db_host_ip    = "10.0.0.100"
}

resource "random_password" "db_password" {
  length  = 32
  special = false
}

resource "random_password" "root_password" {
  length  = 32
  special = false
}

resource "hcloud_volume" "database_storage" {
  count = length(var.dedi_credentials) > 0 || var.preserve_database ? 1 : 0

  name     = "maniacontrol-mysql-data"
  size     = 10
  format   = "ext4"
  location = var.dc_location
}

resource "hcloud_volume_attachment" "database_storage_attach" {
  count = length(var.dedi_credentials) > 0 ? 1 : 0

  automount = true
  volume_id = hcloud_volume.database_storage[0].id
  server_id = hcloud_server.database[0].id
}

resource "hcloud_server" "database" {
  count = length(var.dedi_credentials) > 0 ? 1 : 0

  name        = "maniacontrol-database"
  image       = var.os_image
  server_type = local.server_types["2"]
  location    = var.dc_location
  ssh_keys    = [hcloud_ssh_key.ssh_key.id]

  user_data = <<EOT
#!/bin/bash

set -x -e

apt update
apt install -y docker.io

for i in $(seq 120); do
  volume_path=$(find /mnt -maxdepth 1 -type d -name 'HC_Volume_*' | head -1)
  if [ "$volume_path" != "" ]; then break; fi
  sleep 1
done
storage_path="$volume_path/mysql"
mkdir -p "$storage_path"

docker run -d --restart always \
    -e 'MYSQL_ROOT_PASSWORD=${random_password.root_password.result}' \
    -e 'MYSQL_DATABASE=${local.database_name}' \
    -e 'MYSQL_USER=${local.database_user}' \
    -e 'MYSQL_PASSWORD=${random_password.db_password.result}' \
    -v "$storage_path:/var/lib/mysql" \
    -p ${local.db_host_ip}:3306:3306 \
    mysql:lts \
    mysqld --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci --innodb-flush-log-at-trx-commit=0 \
    --sql-mode=STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION
EOT

  public_net {
    ipv4_enabled = false
    ipv6_enabled = true
  }

  network {
    network_id = hcloud_network.main_net.id
    ip         = local.db_host_ip
  }

  depends_on = [hcloud_network_subnet.subnet]
}
