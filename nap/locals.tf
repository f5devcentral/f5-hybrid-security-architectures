locals {
  project_prefix = data.tfe_outputs.infra.values.project_prefix
  build_suffix = data.tfe_outputs.infra.values.build_suffix
  aws_region = data.tfe_outputs.infra.values.aws_region
  host = data.tfe_outputs.eks.values.cluster_endpoint
  cluster_ca_certificate = data.tfe_outputs.eks.values.kubeconfig-certificate-authority-data
  cluster_name = data.tfe_outputs.eks.values.cluster_name
  app = format("%s-nap-%s", local.project_prefix, local.build_suffix)
  bigip_cis = try(data.tfe_outputs.bigip-cis[0].values.bigip_cis, "false")
  bigip_k8s_partition = try(data.tfe_outputs.bigip-cis[0].values.bigip_k8s_partition, "")
  bigip_vip = try(data.tfe_outputs.bigip-base[0].values.bigip_public_vip, "")
} 