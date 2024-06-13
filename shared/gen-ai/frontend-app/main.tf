
resource "kubectl_manifest" "ns1" {
    yaml_body = <<YAML
apiVersion: v1
kind: Namespace
metadata:
  name: genai-apps
YAML
}

resource "kubectl_manifest" "ns2" {
    yaml_body = <<YAML
apiVersion: v1
kind: Namespace
metadata:
  name: llm
YAML
}

resource "kubectl_manifest" "langchain-search-service" {
    yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  name: langchain-search
  labels:
    app: langchain-search
  namespace: genai-apps
spec:
  type: ClusterIP
  ports:
  - port: 8501
  selector:
    app: langchain-search
YAML
}

resource "kubectl_manifest" "langchain-search-deployment" {
    yaml_body = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: langchain-search
  namespace: genai-apps
spec:
  selector:
    matchLabels:
      app: langchain-search
  replicas: 1
  template:
    metadata:
      labels:
        app: langchain-search
    spec:
      containers:
      - name: langchain-search
        image: registry.gitlab.com/f5-public/langchain-search:latest
        imagePullPolicy: Always
        ports:
        - containerPort: 8501
        env:
          - name: OPENAI_API_BASE
            value: "http://llama.llm/v1"
YAML
}
