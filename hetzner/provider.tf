terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">=1.62.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">=3.7.2"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

provider "random" {
}
