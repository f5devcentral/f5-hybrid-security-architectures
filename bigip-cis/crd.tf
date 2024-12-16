resource "kubectl_manifest" "vs-cis" {
    yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: virtualservers.cis.f5.com
spec:
  group: cis.f5.com
  names:
    kind: VirtualServer
    plural: virtualservers
    shortNames:
      - vs
    singular: virtualserver
  scope: Namespaced
  versions:
    -
      name: v1
      served: true
      storage: true
      schema:
        openAPIV3Schema:
          type: object
          properties:
            spec:
              type: object
              properties:
                host:
                  type: string
                  pattern: '^(([a-zA-Z0-9\*]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$'
                hostGroup:
                  type: string
                  pattern: '^([A-z0-9-_+])*([A-z0-9])$'
                httpTraffic:
                  type: string
                ipamLabel:
                  type: string
                snat:
                  type: string
                tlsProfileName:
                  type: string
                policyName:
                  type: string
                  pattern: '^([A-z0-9-_+])*([A-z0-9])$'
                rewriteAppRoot:
                  type: string
                  pattern: '^\/([A-z0-9-_+]+\/)*([A-z0-9]+\/?)*$'
                waf:
                  type: string
                  pattern: '^\/([A-z0-9-_+]+\/)*([A-z0-9]+\/?)*$'
                allowVlans:
                  items:
                    type: string
                    pattern: '^\/([A-z0-9-_+]+\/)*([A-z0-9-_]+\/?)*$'
                  type: array
                iRules:
                  type: array
                  items:
                    type: string
                serviceAddress:
                  type: array
                  maxItems: 1
                  items:
                    type: object
                    properties:
                      arpEnabled:
                        type: boolean
                      icmpEcho:
                        type: string
                        enum: [enable, disable, selective]
                      routeAdvertisement:
                        type: string
                        enum: [enable, disable, selective, always, any, all]
                      spanningEnabled:
                        type: boolean
                      trafficGroup:
                        type: string
                        pattern: '^\/([A-z0-9-_+]+\/)*([A-z0-9]+\/?)*$'
                pools:
                  type: array
                  items:
                    type: object
                    properties:
                      path:
                        type: string
                        pattern: '^\/([A-z0-9-_+]+\/)*([A-z0-9]+\/?)*$'
                      service:
                        type: string
                        pattern: '^([A-z0-9-_+])*([A-z0-9])$'
                      nodeMemberLabel:
                        type: string
                        pattern: '^[a-zA-Z0-9][-A-Za-z0-9_.\/]{0,61}[a-zA-Z0-9]=[a-zA-Z0-9][-A-Za-z0-9_.]{0,61}[a-zA-Z0-9]$'
                      servicePort:
                        type: integer
                        minimum: 1
                        maximum: 65535
                      rewrite:
                        type: string
                        pattern: '^\/([A-z0-9-_+]+\/)*([A-z0-9]+\/?)*$'
                      monitor:
                        type: object
                        properties:
                          type:
                            type: string
                            enum: [http, https]
                          send:
                            type: string
                          recv:
                            type: string
                          interval:
                            type: integer
                          timeout:
                            type: integer
                        required:
                          - type
                          - send
                          - interval
                virtualServerAddress:
                  type: string
                  pattern: '^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$'
                virtualServerName:
                  type: string
                  pattern: '^([A-z0-9-_+])*([A-z0-9])$'
                virtualServerHTTPPort:
                  type: integer
                  minimum: 1
                  maximum: 65535
                virtualServerHTTPSPort:
                  type: integer
                  minimum: 1
                  maximum: 65535
            status:
              type: object
              properties:
                vsAddress:
                  type: string
                  default: None
                status:
                  type: string
                  default: Pending
      additionalPrinterColumns:
        - name: host
          type: string
          description: hostname
          jsonPath: .spec.host
        - name: tlsProfileName
          type: string
          description: TLS Profile attached
          jsonPath: .spec.tlsProfileName
        - name: httpTraffic
          type: string
          description: Http Traffic Termination
          jsonPath: .spec.httpTraffic
        - name: IPAddress
          type: string
          description: IP address of virtualServer
          jsonPath: .spec.virtualServerAddress
        - name: ipamLabel
          type: string
          description: ipamLabel for virtual server
          jsonPath: .spec.ipamLabel
        - name: IPAMVSAddress
          type: string
          description: IP address of virtualServer
          jsonPath: .status.vsAddress
        - name: STATUS
          type: string
          description: status of VirtualServer
          jsonPath: .status.status
        - name: Age
          type: date
          jsonPath: .metadata.creationTimestamp
      subresources:
        status: {}
YAML
}

resource "kubectl_manifest" "tlsprofiles-cis" {
    yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: tlsprofiles.cis.f5.com
spec:
  group: cis.f5.com
  names:
    kind: TLSProfile
    plural: tlsprofiles
    shortNames:
      - tls
    singular: tlsprofile
  scope: Namespaced
  versions:
    -
      name: v1
      served: true
      storage: true
      schema:
        openAPIV3Schema:
          type: object
          properties:
            spec:
              type: object
              properties:
                hosts:
                  type: array
                  items:
                    type: string
                    pattern: '^(([a-zA-Z0-9\*]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$'
                tls:
                  type: object
                  properties:
                    termination:
                      type: string
                      enum: [edge, reencrypt, passthrough]
                    clientSSL:
                      type: string
                    serverSSL:
                      type: string
                    reference:
                      type: string
                  required:
                    - termination
YAML
}

resource "kubectl_manifest" "transportservers-cis" {
    yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: transportservers.cis.f5.com
spec:
  group: cis.f5.com
  names:
    kind: TransportServer
    plural: transportservers
    shortNames:
      - ts
    singular: transportserver
  scope: Namespaced
  versions:
    -
      name: v1
      served: true
      storage: true
      schema:
        openAPIV3Schema:
          type: object
          properties:
            spec:
              type: object
              properties:
                virtualServerAddress:
                  type: string
                  pattern: '^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$'
                virtualServerPort:
                  type: integer
                  minimum: 1
                  maximum: 65535
                virtualServerName:
                  type: string
                  pattern: '^([A-z0-9-_+])*([A-z0-9])$'
                policyName:
                  type: string
                  pattern: '^([A-z0-9-_+])*([A-z0-9])$'
                mode: 
                  type: string
                  enum: [standard, performance]
                type:
                  type: string
                  enum: [tcp, udp]
                snat:
                  type: string
                allowVlans:
                  items:
                    type: string
                    pattern: '^\/([A-z0-9-_+]+\/)*([A-z0-9-_]+\/?)*$'
                  type: array
                iRules:
                  type: array
                  items:
                    type: string
                ipamLabel:
                  type: string
                serviceAddress:
                  type: array
                  maxItems: 1
                  items:
                    type: object
                    properties:
                      arpEnabled:
                        type: boolean
                      icmpEcho:
                        type: string
                        enum: [enable, disable, selective]
                      routeAdvertisement:
                        type: string
                        enum: [enable, disable, selective, always, any, all]
                      spanningEnabled:
                        type: boolean
                      trafficGroup:
                        type: string
                        pattern: '^\/([A-z0-9-_+]+\/)*([A-z0-9]+\/?)*$'
                pool:
                  type: object
                  properties:
                    service:
                      type: string
                      pattern: '^([A-z0-9-_+])*([A-z0-9])$'
                    servicePort:
                      type: integer
                      minimum: 1
                      maximum: 65535
                    monitor:
                      type: object
                      properties:
                        type:
                          type: string
                          enum: [tcp, udp]
                        interval:
                          type: integer
                        timeout:
                          type: integer
                      required:
                        - type
                        - interval
                  required:
                      - service
                      - servicePort
              required:
                - virtualServerPort
                - pool
            status:
              type: object
              properties:
                vsAddress:
                  type: string
                  default: None
                status:
                  type: string
                  default: Pending
      additionalPrinterColumns:
      - name: virtualServerAddress
        type: string
        description: IP address of virtualServer
        jsonPath: .spec.virtualServerAddress
      - name: virtualServerPort
        type: integer
        description: Port of virtualServer
        jsonPath: .spec.virtualServerPort
      - name: pool
        type: string
        description: Name of service
        jsonPath: .spec.pool.service
      - name: poolPort
        type: string
        description: Port of service
        jsonPath: .spec.pool.servicePort
      - name: ipamLabel
        type: string
        description: ipamLabel for transport server
        jsonPath: .spec.ipamLabel
      - name: IPAMVSAddress
        type: string
        description: IP address of transport server
        jsonPath: .status.vsAddress
      - name: STATUS
        type: string
        description: status of TransportServer
        jsonPath: .status.status
      - name: Age
        type: date
        jsonPath: .metadata.creationTimestamp
      subresources:
        status: { }
YAML
}

resource "kubectl_manifest" "externaldnses-cis" {
    yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: externaldnses.cis.f5.com
spec:
  group: cis.f5.com
  names:
    kind: ExternalDNS
    plural: externaldnses
    shortNames:
      - edns
    singular: externaldns
  scope: Namespaced
  versions:
    -
      name: v1
      served: true
      storage: true
      schema:
        openAPIV3Schema:
          type: object
          properties:
            spec:
              type: object
              properties:
                domainName:
                  type: string
                  pattern: '^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$'
                dnsRecordType:
                  type: string
                  pattern: 'A'
                loadBalanceMethod:
                  type: string
                pools:
                  type: array
                  items:
                    type: object
                    properties:
                      dataServerName:
                        type: string
                      dnsRecordType:
                        type: string
                        pattern: 'A'
                      loadBalanceMethod:
                        type: string
                      monitor:
                        type: object
                        properties:
                          type:
                            type: string
                            enum: [http, https, tcp]
                          send:
                            type: string
                          recv:
                            type: string
                          interval:
                            type: integer
                          timeout:
                            type: integer
                        required:
                          - type
                          - interval
                    required:
                      - dataServerName
              required:
                - domainName
      additionalPrinterColumns:
        - name: domainName
          type: string
          description: Domain name of virtual server resource
          jsonPath: .spec.domainName
        - name: Age
          type: date
          jsonPath: .metadata.creationTimestamp
        - name: CREATED ON
          type: string
          jsonPath: .metadata.creationTimestamp
YAML
}

resource "kubectl_manifest" "ingresslink-cis" {
    yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: ingresslinks.cis.f5.com
spec:
  group: cis.f5.com
  names:
    kind: IngressLink
    shortNames:
      - il
    singular: ingresslink
    plural: ingresslinks
  scope: Namespaced
  versions:
    -
      name: v1
      served: true
      storage: true
      schema:
        openAPIV3Schema:
          type: object
          properties:
            spec:
              type: object
              properties:
                virtualServerAddress:
                  type: string
                  pattern: '^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$'
                ipamLabel:
                  type: string
                iRules:
                  type: array
                  items:
                    type: string
                selector:
                  properties:
                    matchLabels:
                      additionalProperties:
                        type: string
                      type: object
                  type: object
            status:
              type: object
              properties:
                vsAddress:
                  type: string
      additionalPrinterColumns:
        - name: IPAMVSAddress
          type: string
          description: IP address of virtualServer
          jsonPath: .status.vsAddress
        - name: Age
          type: date
          jsonPath: .metadata.creationTimestamp
      subresources:
        status: { }
YAML
}

resource "kubectl_manifest" "policies-cis" {
    yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: policies.cis.f5.com
spec:
  group: cis.f5.com
  names:
    kind: Policy
    shortNames:
      - plc
    singular: policy
    plural: policies
  scope: Namespaced
  versions:
    -
      name: v1
      served: true
      storage: true
      schema:
        openAPIV3Schema:
          type: object
          properties:
            spec:
              type: object
              properties:
                l7Policies:
                  type: object
                  properties:
                    waf:
                      type: string
                      pattern: '^\/([A-z0-9-_+]+\/)+([A-z0-9]+\/?)*$'
                l3Policies:
                  type: object
                  properties:
                    dos:
                      type: string
                      pattern: '^\/([A-z0-9-_+]+\/)+([A-z0-9]+\/?)*$'
                    firewallPolicy:
                      type: string
                      pattern: '^\/([A-z0-9-_+]+\/)+([A-z0-9]+\/?)*$'
                ltmPolicies:
                  type: object
                  properties:
                    insecure:
                      type: string
                      pattern: '^\/([A-z0-9-_+]+\/)+([A-z0-9]+\/?)*$'
                    secure:
                      type: string
                      pattern: '^\/([A-z0-9-_+]+\/)+([A-z0-9]+\/?)*$'
                    priority:
                      type: string
                      enum: [low, high]
                iRules:
                  type: object
                  properties:
                    insecure:
                      type: string
                      pattern: '^\/([A-z0-9-_+]+\/)+([A-z0-9]+\/?)*$'
                    secure:
                      type: string
                      pattern: '^\/([A-z0-9-_+]+\/)+([A-z0-9]+\/?)*$'
                    priority:
                      type: string
                      enum: [ low, high ]
                profiles:
                  type: object
                  properties:
                    tcp:
                      type: string
                      pattern: '^\/([A-z0-9-_+]+\/)+([A-z0-9-]+\/?)*$'
                    udp:
                      type: string
                      pattern: '^\/([A-z0-9-_+]+\/)+([A-z0-9-]+\/?)*$'
                    http:
                      type: string
                      pattern: '^\/([A-z0-9-_+]+\/)+([A-z0-9-]+\/?)*$'
                    http2:
                      type: string
                      pattern: '^\/([A-z0-9-_+]+\/)+([A-z0-9-]+\/?)*$'
                    rewriteProfile:
                      type: string
                      pattern: '^\/([A-z0-9-_+]+\/)+([A-z0-9]+\/?)*$'
                    logProfiles:
                      items:
                        type: string
                        pattern: '^\/([A-z0-9-_+]+\/)*([A-z0-9-_\s]+\/?)*$'
                      type: array
YAML
}