resource "kubectl_manifest" "ingress-link" {
  count = local.bigip_cis ? 1 : 0
    yaml_body = <<YAML
apiVersion: "cis.f5.com/v1"
kind: IngressLink
metadata:
  name: vs-ingresslink
  namespace: nginx-ingress
spec:
  virtualServerAddress: ${local.bigip_vip}
  iRules:
    - /Common/Shared/Proxy_Protocol_iRule
  selector:
    matchLabels:
      app: ${local.app}-nginx-ingress     
 YAML 
}