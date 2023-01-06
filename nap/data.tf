data "tfe_outputs" "infra" {
  organization = "knowbase"
  workspace = "xc-bigip-test"
}
data "tfe_outputs" "eks" {
  organization = "knowbase"
  workspace = "xc-nap-eks"
}
