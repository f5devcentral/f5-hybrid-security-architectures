resource "helm_release" "nginx-plus-ingress" {
  count = local.bigip_cis ? 0 : 1
    name = format("%s-nap-%s", local.project_prefix, local.build_suffix)
    repository = "https://helm.nginx.com/stable"
    chart = "nginx-ingress"
    #version = "0.16.2"
    namespace = kubernetes_namespace.nginx-ingress.metadata[0].name
    values = [file("./charts/nginx-app-protect/values.yaml")]

    depends_on = [
      kubernetes_secret.docker-registry
    ]
}
resource "helm_release" "nginx-plus-ingresslink" {
  count = local.bigip_cis ? 1 : 0
    name = format("%s-nap-%s", local.project_prefix, local.build_suffix)
    repository = "https://helm.nginx.com/stable"
    chart = "nginx-ingress"
    #version = "0.16.2"
    namespace = kubernetes_namespace.nginx-ingress.metadata[0].name
    values = [templatefile("./charts/nap-ingresslink/values.yaml", { app = "${local.app}"})]

    depends_on = [
      kubernetes_secret.docker-registry
    ]
}
