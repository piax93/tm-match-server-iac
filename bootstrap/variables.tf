variable "admins" {
  type        = list(string)
  description = "List of login IDs of server admins"
}
variable "maps" {
  type        = map(string)
  description = "Name => download URL mapping of maps to load on servers"
}
variable "dedi_login" {
  type        = string
  description = "Login name for dedicated server (https://www.trackmania.com/player/dedicated-servers)"
}
variable "dedi_password" {
  type        = string
  description = "Login password for dedicated server (https://www.trackmania.com/player/dedicated-servers)"
  sensitive   = true
}
variable "room_password" {
  type        = string
  description = "Player password for server"
  sensitive   = true
}
variable "db_host" {
  type        = string
  description = "Mysql database server hostname"
}
variable "db_name" {
  type        = string
  description = "Mysql database schema name"
}
variable "db_user" {
  type        = string
  description = "Mysql database username"
}
variable "db_password" {
  type        = string
  description = "Mysql database password"
  sensitive   = true
}
