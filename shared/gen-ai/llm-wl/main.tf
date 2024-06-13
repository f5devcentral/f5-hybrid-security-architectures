resource "kubectl_manifest" "ns" {
    yaml_body = <<YAML
apiVersion: v1
kind: Namespace
metadata:
  name: llm
YAML
}


resource "kubectl_manifest" "llama-service" {
    yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  name: llama
  labels:
    app: llama
  namespace: llm
spec:
  type: ClusterIP
  ports:
  - port: 8000
  selector:
    app: llama
YAML
}


resource "kubectl_manifest" "llama-deployment" {
    yaml_body = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: llama
  namespace: llm
spec:
  selector:
    matchLabels:
      app: llama
  replicas: 1
  template:
    metadata:
      labels:
        app: llama
    spec:
      containers:
      - name: llama
        image: registry.gitlab.com/f5-public/llama-cpp-python:latest
        imagePullPolicy: Always
        ports:
        - containerPort: 8000
YAML

  wait = true

  timeouts {
    create = "20m"
  }
}
