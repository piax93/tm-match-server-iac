output "bootstrap_script" {
  sensitive = true
  value = templatefile(
    "${path.module}/bootstrap.sh.tpl",
    {
      admins        = var.admins,
      maps          = var.maps,
      dedi_login    = var.dedi_login,
      dedi_password = var.dedi_password,
      room_password = var.room_password,
      db_host       = var.db_host,
      db_name       = var.db_name,
      db_user       = var.db_user,
      db_password   = var.db_password,
    }
  )
}
