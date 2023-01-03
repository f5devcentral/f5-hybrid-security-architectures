terraform {
  required_version = ">= 0.14.0"
  required_providers {
    aws = ">= 4"
    volterra = {
      source = "volterraedge/volterra"
      version = "0.11.5"
    }
  }
}