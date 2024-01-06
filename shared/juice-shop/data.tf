data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}
data "tfe_outputs" "infra" {
  organization = var.tf_cloud_organization
  workspace = "infra"
}
