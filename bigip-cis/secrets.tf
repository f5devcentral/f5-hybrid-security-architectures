resource "kubernetes_secret" "bigip-login" {
  metadata {
    name = "bigip-login"
    namespace = "kube-system"
  }
  data = {
    username = "admin"
    password = data.tfe_outputs.bigip-base.values.bigip_password
  }
}