resource "kubernetes_manifest" "virtual_server" {
  manifest = <<-EOT
    apiVersion: k8s.nginx.org/v1
    kind: VirtualServer
    metadata:
      name: brewz
    spec:
      host: brewz.sr.f5-cloud-demo.com
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
  EOT
}