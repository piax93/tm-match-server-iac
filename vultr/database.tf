locals {
  database_name = "maniacontrol"
  database_user = "maniacontrol"
}

resource "random_password" "db_password" {
  length  = 32
  special = false
}

resource "random_password" "root_password" {
  length  = 32
  special = false
}

resource "vultr_block_storage" "database_storage" {
  count = length(var.dedi_credentials) > 0 || var.preserve_database ? 1 : 0

  label    = "maniacontrol-mysql-data"
  size_gb  = 10
  live     = true
  bootable = false

  attached_to_instance = length(var.dedi_credentials) > 0 ? vultr_instance.database[0].id : null

  region = var.dc_location
}

resource "vultr_instance" "database" {
  count = length(var.dedi_credentials) > 0 ? 1 : 0

  label       = "maniacontrol-database"
  plan        = local.server_types["2"]
  os_id       = data.vultr_os.operating_system.id
  ssh_key_ids = [vultr_ssh_key.ssh_key.id]
  script_id   = vultr_startup_script.database_startup.id

  vpc_ids             = [vultr_vpc.vpc.id]
  disable_public_ipv4 = false
  enable_ipv6         = false

  region = var.dc_location
}

resource "vultr_startup_script" "database_startup" {
  name = "database-startup"
  script = base64encode(<<EOT
#!/bin/bash

set -x -e

apt update
apt install -y docker.io

echo "Waiting for block device to be mounted"
device_name='vdb'
for i in $(seq 120); do
  device_path=$(find /dev -maxdepth 1 -name "$device_name" | head -1)
  if [ "$device_path" != "" ]; then break; fi
  sleep 1
done

volume_path="$${device_path}1"
if [ "$(sfdisk -d "$device_path" 2>&1 | grep -o 'label: gpt')" == "" ]; then
  echo "Partitioning storage disk for the first time"
  parted -s "$device_path" mklabel gpt
  parted -s "$device_path" unit mib mkpart primary 0% 100%
  mkfs.ext4 "$volume_path"
fi

mount_path='/mnt/block'
mkdir -p "$mount_path"
mount "$volume_path" "$mount_path"
storage_path="$mount_path/mysql"
mkdir -p "$storage_path"

docker run -d --restart always \
    -e 'MYSQL_ROOT_PASSWORD=${random_password.root_password.result}' \
    -e 'MYSQL_DATABASE=${local.database_name}' \
    -e 'MYSQL_USER=${local.database_user}' \
    -e 'MYSQL_PASSWORD=${random_password.db_password.result}' \
    -v "$storage_path:/var/lib/mysql" \
    -p $(hostname -I | grep -oE '10\.\S+'):3306:3306 \
    mysql:lts \
    mysqld --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci --innodb-flush-log-at-trx-commit=0 \
    --sql-mode=STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION
EOT
  )

}

output "database_ip" {
  value = length(var.dedi_credentials) > 0 ? vultr_instance.database[0].main_ip : null
}
