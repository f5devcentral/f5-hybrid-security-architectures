resource "helm_release" "grafana" {
    name = format("%s-gfa-%s", local.project_prefix, local.build_suffix)
    repository = "https://grafana.github.io/helm-charts"
    chart = "grafana"
    version = "6.31.1"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
    values = [templatefile("./charts/grafana/values.yaml", { external_name = "${data.kubernetes_service_v1.nginx-service.status.0.load_balancer.0.ingress.0.hostname}"})]
}