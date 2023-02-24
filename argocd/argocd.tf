resource "helm_release" "argocd" {
  name       = format("%s-argocd-%s", local.project_prefix, local.build_suffix)
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  version    = "5.21.0"
  values = [file("./charts/values.yaml")]
}