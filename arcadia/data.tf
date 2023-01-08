data "tfe_outputs" "infra" {
  organization = "knowbase"
  workspace = "infra"
}
data "tfe_outputs" "eks" {
  organization = "knowbase"
  workspace = "eks"
}
data "tfe_outputs" "nap" {
  organization = "knowbase"
  workspace = "nap-kic"
}
data "aws_eks_cluster_auth" "auth" {
  name = data.tfe_outputs.eks.values.cluster_name
}
