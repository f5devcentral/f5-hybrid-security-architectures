resource "kubectl_manifest" "nginx-config" {
    yaml_body = <<YAML
kind: ConfigMap
apiVersion: v1
metadata:
  name: nginx-config
  namespace: nginx-ingress
data:
YAML
}
