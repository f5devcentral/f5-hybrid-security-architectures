data "tfe_outputs" "bigip" {
  organization = "knowbase"
  workspace = "xc-bigip-bip"
}
data "tfe_outputs" "infra" {
  organization = "knowbase"
  workspace = "onewaap-infra"
}