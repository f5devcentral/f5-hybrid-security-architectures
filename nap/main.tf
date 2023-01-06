provider "aws" {
    region     = local.aws_region
}
provider "kubernetes" {
    host = local.host
    cluster_ca_certificate = base64decode(local.cluster_ca_certificate)
    token = data.aws_eks_cluster_auth.auth.token
    #token = local.token
    /*
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", local.cluster_name]
    command     = "aws"
  }
  */
}