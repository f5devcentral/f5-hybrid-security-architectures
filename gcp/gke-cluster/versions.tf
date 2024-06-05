terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = ">=5.30.0"
    }
  }

  required_version = ">= 0.14.0"
}
