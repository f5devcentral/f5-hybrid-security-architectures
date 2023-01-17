resource "helm_release" "nginx-plus-ingress" {
    name = format("%s-nap-%s", local.project_prefix, local.build_suffix)
    repository = "https://helm.nginx.com/stable"
    chart = "nginx-ingress"
    namespace = kubernetes_namespace.nginx-ingress.metadata[0].name
    values = [file("./charts/nginx-plus-ingress/values.yaml")]

    depends_on = [
      kubernetes_secret.docker-registry
    ]
}