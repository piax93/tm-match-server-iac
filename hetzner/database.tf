locals {
  database_name = "maniacontrol"
  database_user = "maniacontrol"
  db_host_ip    = "10.0.0.10"
}

resource "random_password" "db_password" {
  length  = 32
  special = false
}

resource "random_password" "root_password" {
  length  = 32
  special = false
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

docker run -d --restart always \
    -e 'MYSQL_ROOT_PASSWORD=${random_password.root_password.result}' \
    -e 'MYSQL_DATABASE=${local.database_name}' \
    -e 'MYSQL_USER=${local.database_user}' \
    -e 'MYSQL_PASSWORD=${random_password.db_password.result}' \
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
