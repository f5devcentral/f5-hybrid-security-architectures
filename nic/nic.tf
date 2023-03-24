resource "helm_release" "nginx-plus-ingress" {
  count = local.bigip_cis ? 0 : 1
    name = format("%s-nic-%s", local.project_prefix, local.build_suffix)
    repository = "https://helm.nginx.com/stable"
    chart = "nginx-ingress"
    namespace = kubernetes_namespace.nginx-ingress.metadata[0].name
    values = [file("./charts/nginx-plus-ingress/values.yaml")]

    depends_on = [
      kubernetes_secret.docker-registry
    ]
}
resource "helm_release" "nginx-plus-ingresslink" {
  count = local.bigip_cis ? 1 : 0
    name = format("%s-nic-%s", local.project_prefix, local.build_suffix)
    repository = "https://helm.nginx.com/stable"
    chart = "nginx-ingress"
    namespace = kubernetes_namespace.nginx-ingress.metadata[0].name
    values = [file("./charts/nginx-plus-ingresslink/values.yaml")]

    depends_on = [
      kubernetes_secret.docker-registry
    ]
}