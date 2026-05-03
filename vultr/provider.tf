terraform {
  required_providers {
    vultr = {
      source  = "vultr/vultr"
      version = ">=2.31.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">=3.7.2"
    }
  }
}

provider "vultr" {
  api_key     = var.vultr_token
  rate_limit  = 100
  retry_limit = 3
}

provider "random" {
}
