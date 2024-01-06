resource "kubectl_manifest" "virtual_server" {
    yaml_body = <<YAML
apiVersion: k8s.nginx.org/v1
kind: VirtualServer
metadata:
  name: brewz
spec:
  host: "${local.external_name}"
  upstreams:
    - name: spa
      service: spa
      port: 80
    - name: api
      service: api
      port: 8000
  routes:
    - path: /
      action:
        pass: spa
    - path: /api
      action:
        pass: api
    - path: /images
      action:
        proxy:
          upstream: api
          rewritePath: /images
YAML
}