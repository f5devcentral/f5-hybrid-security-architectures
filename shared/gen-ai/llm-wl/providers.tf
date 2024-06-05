provider "aws" {
    region     = local.aws_region
}

provider "kubectl" {
    host = local.host
    cluster_ca_certificate = base64decode(local.cluster_ca_certificate)
    token = data.aws_eks_cluster_auth.auth.token
    load_config_file       = false
}