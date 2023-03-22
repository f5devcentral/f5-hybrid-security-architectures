resource "kubernetes_cluster_role_v1" "cis-role" {
    metadata {
        name = "bigip-ctlr-clusterrole"
    }
    rule {
        api_groups = ["", "extensions", "networking.k8s.io", "route.openshift.io"]
        resources = ["nodes", "services", "endpoints", "namespaces", "ingresses", "pods", "ingressclasses", "policies", "routes"]
        verbs = ["get", "list", "watch"]
    }
    rule {
        api_groups = ["", "extensions", "networking.k8s.io", "route.openshift.io"]
        resources = ["configmaps", "events", "ingresses/status", "services/status", "routes/status"]
        verbs = ["get", "list", "watch", "update", "create", "patch"]
    }
    rule {
        api_groups = ["cis.f5.com"]
        resources = ["virtualservers","virtualservers/status", "tlsprofiles", "transportservers", "transportservers/status", "ingresslinks", "ingresslinks/status", "externaldnses", "policies"]
        verbs = ["get", "list", "watch", "update", "patch"]
    }
    rule {
        api_groups = ["fic.f5.com"]
        resources = ["ipams", "ipams/status"]
        verbs = ["get", "list", "watch", "update", "create", "patch", "delete"]
    }
    rule {
        api_groups = ["apiextensions.k8s.io"]
        resources = ["customresourcedefinitions"]
        verbs = ["get", "list", "watch", "update", "create", "patch"]
    }
    rule {
        api_groups = ["", "extensions"]
        resources = ["secrets"]
        verbs = ["get", "list", "watch"]
    }
    rule {
        api_groups = ["config.openshift.io/v1"]
        resources = ["network"]
        verbs = ["list"]
    }
}

resource "kubernetes_cluster_role_binding_v1" "bigip-role-binding" {
    metadata {
        name = "bigip-ctlr-clusterrole-binding"
    }
    role_ref {
        api_group = "rbac.authorization.k8s.io"
        kind      = "ClusterRole"
        name      = "bigip-ctlr-clusterrole"
    }
    subject {
        kind      = "ServiceAccount"
        name      = "bigip-ctlr"
        namespace = "kube-system"
        api_group = ""
    }
}

resource "kubernetes_service_account_v1" "bigip-ctlr" {
  metadata {
    name = "bigip-ctlr"
    namespace = "kube-system"
  }
}