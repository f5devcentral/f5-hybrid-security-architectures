#Project Globals
variable "admin_src_addr" {
  type        = string
  description = "Allowed Admin source IP prefix"
  default     = "0.0.0.0/0"
}
#TF Cloud
variable "tf_cloud_organization" {
  type = string
  description = "TF cloud org (Value set in TF cloud)"
}
#AWS
variable "eks_addons" {
  type = list(object({
    name    = string
    version = string
  }))
  default = [
    {
      name    = "kube-proxy"
      version = "v1.25.6-eksbuild.1"
    },
    {
      name    = "vpc-cni"
      version = "v1.12.2-eksbuild.1"
    },
    {
      name    = "coredns"
      version = "v1.8.7-eksbuild.3"
    },
    {
      name    = "aws-ebs-csi-driver"
      version = "v1.13.0-eksbuild.3"
    }
  ]
}
variable "ssh_key" {
  type        = string
  description = "Unneeded for EKS, only present for warning handling with TF cloud variable set"
}











