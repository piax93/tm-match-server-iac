locals {
  dedi_credentials = {
    for creds in var.dedi_credentials :
    creds.login => creds.password
  }
  server_types = {
    1 = "vhp-1c-2gb-amd",
    2 = "vhp-2c-2gb-amd",
    4 = "vhp-4c-8gb-amd",
    8 = "vhp-8c-16gb-amd",
  }
}

data "vultr_os" "operating_system" {
  filter {
    name   = "name"
    values = [var.os_image]
  }
}

resource "vultr_ssh_key" "ssh_key" {
  name    = "tm-ssh-key"
  ssh_key = var.ssh_key
}

module "bootstrap" {
  source = "../bootstrap"

  for_each = local.dedi_credentials

  admins        = var.admins
  maps          = var.maps
  dedi_login    = each.key
  dedi_password = each.value
  room_password = var.room_password

  db_host     = vultr_instance.database[0].internal_ip
  db_name     = local.database_name
  db_user     = local.database_user
  db_password = random_password.db_password.result
}

resource "vultr_instance" "server" {
  for_each = local.dedi_credentials

  label       = "tm-match-${each.key}"
  plan        = local.server_types[var.cpu_cores]
  os_id       = data.vultr_os.operating_system.id
  ssh_key_ids = [vultr_ssh_key.ssh_key.id]
  script_id   = vultr_startup_script.server_script[each.key].id

  vpc_ids             = [vultr_vpc.vpc.id]
  disable_public_ipv4 = false
  enable_ipv6         = false

  region = var.dc_location

  depends_on = [
    vultr_instance.database,
  ]
}

resource "vultr_startup_script" "server_script" {
  for_each = local.dedi_credentials

  name   = "server-startup-${each.key}"
  script = base64encode(module.bootstrap[each.key].bootstrap_script)
}

output "server_ips" {
  value = [for _, s in vultr_instance.server : s.main_ip]
}
