resource "kubectl_manifest" "nginx" {
    yaml_body = <<YAML
apiVersion: networking.k8s.io/v1
kind: IngressClass
metadata:
  name: nginx
  # annotations:
  #   ingressclass.kubernetes.io/is-default-class: "true"
spec:
  controller: nginx.org/ingress-controller
YAML
}