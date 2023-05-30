locals {
  #GLOBAL
  project_prefix = data.tfe_outputs.infra.values.project_prefix
  aws_region = data.tfe_outputs.infra.values.aws_region
  resource_owner = data.tfe_outputs.infra.values.resource_owner

  #BIGIP
  bigip_password = data.tfe_outputs.bigip-base.values.bigip_password
  bigip_address = data.tfe_outputs.bigip-base.values.bigip_mgmt_ip
  bigip_vip = data.tfe_outputs.bigip-base.values.bigip_public_vip
  bigip_mgmt = data.aws_instance.bigip.private_ip

  #EKS
  host = data.tfe_outputs.eks.values.cluster_endpoint
  cluster_ca_certificate = data.tfe_outputs.eks.values.kubeconfig-certificate-authority-data
  cluster_name = data.tfe_outputs.eks.values.cluster_name
}