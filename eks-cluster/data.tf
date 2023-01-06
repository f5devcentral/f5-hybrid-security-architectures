data "tfe_outputs" "infra" {
  organization = "knowbase"
  workspace = "xc-bigip-test"
}
/*
data "aws_eks_cluster_auth" "auth" {
  name = aws_eks_cluster.eks-tf.name
}
*/
