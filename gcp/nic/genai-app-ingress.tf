resource "kubectl_manifest" "genai-app-ingress" {
    yaml_body = <<YAML
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: langchain-search
  namespace: genai-apps
  annotations:
    nginx.org/websocket-services: "langchain-search"
    nginx.org/proxy-read-timeout: "3600"
    nginx.org/proxy-send-timeout: "3600"
spec:
  ingressClassName: nginx
  defaultBackend:
    service:
      name: langchain-search
      port:
        number: 8501
  rules:
  - host: "*.com"
    http:
      paths:
      - path: "/"
        pathType: Prefix
        backend:
          service:
            name: langchain-search
            port:
              number: 8501
YAML
}