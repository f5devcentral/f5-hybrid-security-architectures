terraform {
  required_version = ">= 0.14.0"
  required_providers {
    aws = ">= 4"
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.16.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">=2.7.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
  }
}