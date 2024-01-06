resource "kubernetes_cluster_role" "crapi-role" {
    metadata {
      name = "crapi-waitfor-reader"
    }
    rule {
      api_groups = [""]
      resources = ["services","pods"]
      verbs = ["get", "watch", "list"]
    } 
}
resource "kubernetes_role_binding_v1" "crapi-role-binding" {
    metadata {
      name = "crapi-waitfor-grant"
    }
    role_ref {
      api_group = ""
      kind      = "ClusterRole"
      name      = "crapi-waitfor-reader"
    }
    subject {
        kind      = "ServiceAccount"
        name      = "default"
        namespace = "crapi"
        api_group = ""
    }
}
