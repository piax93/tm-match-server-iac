locals {
  dedi_credentials = {
    for creds in var.dedi_credentials :
    creds.login => creds.password
  }
  server_types = {
    2 = "cpx11",
    3 = "cpx21",
    4 = "cpx31",
    8 = "cpx41",
  }
}

module "bootstrap" {
  source = "../bootstrap"

  for_each = local.dedi_credentials

  admins        = var.admins
  maps          = var.maps
  dedi_login    = each.key
  dedi_password = each.value
  room_password = var.room_password

  db_host     = local.db_host_ip
  db_name     = local.database_name
  db_user     = local.database_user
  db_password = random_password.db_password.result
}

resource "hcloud_ssh_key" "ssh_key" {
  name       = "tm-ssh-key"
  public_key = var.ssh_key
}

resource "hcloud_server" "server" {
  for_each = local.dedi_credentials

  name        = "tm-match-${each.key}"
  image       = var.os_image
  server_type = local.server_types[var.cpu_cores]
  location    = var.dc_location
  ssh_keys    = [hcloud_ssh_key.ssh_key.id]

  user_data = module.bootstrap[each.key].bootstrap_script

  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }

  network {
    network_id = hcloud_network.main_net.id
  }

  depends_on = [
    hcloud_network_subnet.subnet,
    hcloud_server.database,
  ]
}

output "server_ips" {
  value = [for _, s in hcloud_server.server : s.ipv4_address]
}
