resource "vultr_vpc" "vpc" {
  description    = "main-tm-net"
  region         = var.dc_location
  v4_subnet      = "10.0.0.0"
  v4_subnet_mask = 24
}
