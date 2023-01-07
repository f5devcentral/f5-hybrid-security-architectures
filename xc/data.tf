data "tfe_outputs" "infra" {
  organization = "knowbase"
  workspace = "infra"
}
data "tfe_outputs" "bigip" {
  organization = "knowbase"
  workspace = "bigip"
}
data "tfe_outputs" "nap" {
  organization = "knowbase"
  workspace = "nap-kic"
}