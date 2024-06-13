terraform {
  required_version = ">= 0.14.0"
  required_providers {
    #google = {
    #  source = "hashicorp/google"
    #  version = ">= 5.30.0"
    #}
    google = {
      source  = "hashicorp/google"
      version = "4.27.0"
    }
	  kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
  }
}