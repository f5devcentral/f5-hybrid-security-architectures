locals {
  project_prefix = data.tfe_outputs.infra.values.project_prefix
  host = data.tfe_outputs.eks.values.cluster_endpoint
  aws_region = data.tfe_outputs.infra.values.aws_region
  cluster_ca_certificate = data.tfe_outputs.eks.values.kubeconfig-certificate-authority-data
  cluster_name = data.tfe_outputs.eks.values.cluster_name
} 
