resource "kubectl_manifest" "ns" {
    yaml_body = <<YAML
apiVersion: v1
kind: Namespace
metadata:
  name: nginx-ingress
YAML
}

resource "kubectl_manifest" "sa" {
    yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  name: nginx-ingress
  namespace: nginx-ingress
#automountServiceAccountToken: false
YAML
}

