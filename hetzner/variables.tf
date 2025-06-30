variable "cpu_cores" {
  type        = number
  description = "Number of CPU vcores for each server"
  default     = 2
}
variable "os_image" {
  type        = string
  description = "Operating system image to use"
  default     = "ubuntu-24.04"
}
variable "dc_location" {
  type        = string
  description = "Datacenter where to provision resources"
  default     = "fsn1" # eu-central
}
variable "ssh_key" {
  type        = string
  description = "Public SSH key allowed to access servers"
}
variable "admins" {
  type        = list(string)
  description = "List of login IDs of server admins"
}
variable "maps" {
  type        = map(string)
  description = "Name => download URL mapping of maps to load on servers"
}
variable "dedi_credentials" {
  type = list(object({
    login    = string
    password = string
  }))
  description = "List of dedicated server credentials (https://www.trackmania.com/player/dedicated-servers)"
}
variable "room_password" {
  type        = string
  description = "Player password for servers"
  sensitive   = true
}
variable "hcloud_token" {
  type        = string
  description = "Authentication token for Hetzner"
  sensitive   = true
}
