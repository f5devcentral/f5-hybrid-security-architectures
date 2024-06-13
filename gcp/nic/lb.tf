resource "kubectl_manifest" "lb" {
    yaml_body = <<YAML

apiVersion: v1
kind: Service
metadata:
  name: nginx-ingress
  namespace: nginx-ingress
spec:
  externalTrafficPolicy: Local
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP
    name: http
  - port: 443
    targetPort: 443
    protocol: TCP
    name: https
  selector:
    app: nginx-ingress

YAML
}

resource "null_resource" "lb-wait" {
  depends_on = [kubectl_manifest.lb]
  provisioner "local-exec" {
    command = "sleep 120"
  }
}