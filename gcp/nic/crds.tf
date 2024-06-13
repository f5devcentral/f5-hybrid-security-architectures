resource "kubectl_manifest" "vs" {
    yaml_body = <<YAML
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  annotations:
    controller-gen.kubebuilder.io/version: v0.15.0
  name: virtualservers.k8s.nginx.org
spec:
  group: k8s.nginx.org
  names:
    kind: VirtualServer
    listKind: VirtualServerList
    plural: virtualservers
    shortNames:
    - vs
    singular: virtualserver
  scope: Namespaced
  versions:
  - additionalPrinterColumns:
    - description: Current state of the VirtualServer. If the resource has a valid
        status, it means it has been validated and accepted by the Ingress Controller.
      jsonPath: .status.state
      name: State
      type: string
    - jsonPath: .spec.host
      name: Host
      type: string
    - jsonPath: .status.externalEndpoints[*].ip
      name: IP
      type: string
    - jsonPath: .status.externalEndpoints[*].hostname
      name: ExternalHostname
      priority: 1
      type: string
    - jsonPath: .status.externalEndpoints[*].ports
      name: Ports
      type: string
    - jsonPath: .metadata.creationTimestamp
      name: Age
      type: date
    name: v1
    schema:
      openAPIV3Schema:
        description: VirtualServer defines the VirtualServer resource.
        properties:
          apiVersion:
            description: |-
              APIVersion defines the versioned schema of this representation of an object.
              Servers should convert recognized schemas to the latest internal value, and
              may reject unrecognized values.
              More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
            type: string
          kind:
            description: |-
              Kind is a string value representing the REST resource this object represents.
              Servers may infer this from the endpoint the client submits requests to.
              Cannot be updated.
              In CamelCase.
              More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
            type: string
          metadata:
            type: object
          spec:
            description: VirtualServerSpec is the spec of the VirtualServer resource.
            properties:
              dos:
                type: string
              externalDNS:
                description: ExternalDNS defines externaldns sub-resource of a virtual
                  server.
                properties:
                  enable:
                    type: boolean
                  labels:
                    additionalProperties:
                      type: string
                    description: Labels stores labels defined for the Endpoint
                    type: object
                  providerSpecific:
                    description: ProviderSpecific stores provider specific config
                    items:
                      description: |-
                        ProviderSpecificProperty defines specific property
                        for using with ExternalDNS sub-resource.
                      properties:
                        name:
                          description: Name of the property
                          type: string
                        value:
                          description: Value of the property
                          type: string
                      type: object
                    type: array
                  recordTTL:
                    description: TTL for the record
                    format: int64
                    type: integer
                  recordType:
                    type: string
                type: object
              gunzip:
                type: boolean
              host:
                type: string
              http-snippets:
                type: string
              ingressClassName:
                type: string
              internalRoute:
                description: InternalRoute allows for the configuration of internal
                  routing.
                type: boolean
              listener:
                description: VirtualServerListener references a custom http and/or
                  https listener defined in GlobalConfiguration.
                properties:
                  http:
                    type: string
                  https:
                    type: string
                type: object
              policies:
                items:
                  description: PolicyReference references a policy by name and an
                    optional namespace.
                  properties:
                    name:
                      type: string
                    namespace:
                      type: string
                  type: object
                type: array
              routes:
                items:
                  description: Route defines a route.
                  properties:
                    action:
                      description: Action defines an action.
                      properties:
                        pass:
                          type: string
                        proxy:
                          description: ActionProxy defines a proxy in an Action.
                          properties:
                            requestHeaders:
                              description: ProxyRequestHeaders defines the request
                                headers manipulation in an ActionProxy.
                              properties:
                                pass:
                                  type: boolean
                                set:
                                  items:
                                    description: Header defines an HTTP Header.
                                    properties:
                                      name:
                                        type: string
                                      value:
                                        type: string
                                    type: object
                                  type: array
                              type: object
                            responseHeaders:
                              description: ProxyResponseHeaders defines the response
                                headers manipulation in an ActionProxy.
                              properties:
                                add:
                                  items:
                                    description: AddHeader defines an HTTP Header
                                      with an optional Always field to use with the
                                      add_header NGINX directive.
                                    properties:
                                      always:
                                        type: boolean
                                      name:
                                        type: string
                                      value:
                                        type: string
                                    type: object
                                  type: array
                                hide:
                                  items:
                                    type: string
                                  type: array
                                ignore:
                                  items:
                                    type: string
                                  type: array
                                pass:
                                  items:
                                    type: string
                                  type: array
                              type: object
                            rewritePath:
                              type: string
                            upstream:
                              type: string
                          type: object
                        redirect:
                          description: ActionRedirect defines a redirect in an Action.
                          properties:
                            code:
                              type: integer
                            url:
                              type: string
                          type: object
                        return:
                          description: ActionReturn defines a return in an Action.
                          properties:
                            body:
                              type: string
                            code:
                              type: integer
                            type:
                              type: string
                          type: object
                      type: object
                    dos:
                      type: string
                    errorPages:
                      items:
                        description: ErrorPage defines an ErrorPage in a Route.
                        properties:
                          codes:
                            items:
                              type: integer
                            type: array
                          redirect:
                            description: ErrorPageRedirect defines a redirect for
                              an ErrorPage.
                            properties:
                              code:
                                type: integer
                              url:
                                type: string
                            type: object
                          return:
                            description: ErrorPageReturn defines a return for an ErrorPage.
                            properties:
                              body:
                                type: string
                              code:
                                type: integer
                              headers:
                                items:
                                  description: Header defines an HTTP Header.
                                  properties:
                                    name:
                                      type: string
                                    value:
                                      type: string
                                  type: object
                                type: array
                              type:
                                type: string
                            type: object
                        type: object
                      type: array
                    location-snippets:
                      type: string
                    matches:
                      items:
                        description: Match defines a match.
                        properties:
                          action:
                            description: Action defines an action.
                            properties:
                              pass:
                                type: string
                              proxy:
                                description: ActionProxy defines a proxy in an Action.
                                properties:
                                  requestHeaders:
                                    description: ProxyRequestHeaders defines the request
                                      headers manipulation in an ActionProxy.
                                    properties:
                                      pass:
                                        type: boolean
                                      set:
                                        items:
                                          description: Header defines an HTTP Header.
                                          properties:
                                            name:
                                              type: string
                                            value:
                                              type: string
                                          type: object
                                        type: array
                                    type: object
                                  responseHeaders:
                                    description: ProxyResponseHeaders defines the
                                      response headers manipulation in an ActionProxy.
                                    properties:
                                      add:
                                        items:
                                          description: AddHeader defines an HTTP Header
                                            with an optional Always field to use with
                                            the add_header NGINX directive.
                                          properties:
                                            always:
                                              type: boolean
                                            name:
                                              type: string
                                            value:
                                              type: string
                                          type: object
                                        type: array
                                      hide:
                                        items:
                                          type: string
                                        type: array
                                      ignore:
                                        items:
                                          type: string
                                        type: array
                                      pass:
                                        items:
                                          type: string
                                        type: array
                                    type: object
                                  rewritePath:
                                    type: string
                                  upstream:
                                    type: string
                                type: object
                              redirect:
                                description: ActionRedirect defines a redirect in
                                  an Action.
                                properties:
                                  code:
                                    type: integer
                                  url:
                                    type: string
                                type: object
                              return:
                                description: ActionReturn defines a return in an Action.
                                properties:
                                  body:
                                    type: string
                                  code:
                                    type: integer
                                  type:
                                    type: string
                                type: object
                            type: object
                          conditions:
                            items:
                              description: Condition defines a condition in a MatchRule.
                              properties:
                                argument:
                                  type: string
                                cookie:
                                  type: string
                                header:
                                  type: string
                                value:
                                  type: string
                                variable:
                                  type: string
                              type: object
                            type: array
                          splits:
                            items:
                              description: Split defines a split.
                              properties:
                                action:
                                  description: Action defines an action.
                                  properties:
                                    pass:
                                      type: string
                                    proxy:
                                      description: ActionProxy defines a proxy in
                                        an Action.
                                      properties:
                                        requestHeaders:
                                          description: ProxyRequestHeaders defines
                                            the request headers manipulation in an
                                            ActionProxy.
                                          properties:
                                            pass:
                                              type: boolean
                                            set:
                                              items:
                                                description: Header defines an HTTP
                                                  Header.
                                                properties:
                                                  name:
                                                    type: string
                                                  value:
                                                    type: string
                                                type: object
                                              type: array
                                          type: object
                                        responseHeaders:
                                          description: ProxyResponseHeaders defines
                                            the response headers manipulation in an
                                            ActionProxy.
                                          properties:
                                            add:
                                              items:
                                                description: AddHeader defines an
                                                  HTTP Header with an optional Always
                                                  field to use with the add_header
                                                  NGINX directive.
                                                properties:
                                                  always:
                                                    type: boolean
                                                  name:
                                                    type: string
                                                  value:
                                                    type: string
                                                type: object
                                              type: array
                                            hide:
                                              items:
                                                type: string
                                              type: array
                                            ignore:
                                              items:
                                                type: string
                                              type: array
                                            pass:
                                              items:
                                                type: string
                                              type: array
                                          type: object
                                        rewritePath:
                                          type: string
                                        upstream:
                                          type: string
                                      type: object
                                    redirect:
                                      description: ActionRedirect defines a redirect
                                        in an Action.
                                      properties:
                                        code:
                                          type: integer
                                        url:
                                          type: string
                                      type: object
                                    return:
                                      description: ActionReturn defines a return in
                                        an Action.
                                      properties:
                                        body:
                                          type: string
                                        code:
                                          type: integer
                                        type:
                                          type: string
                                      type: object
                                  type: object
                                weight:
                                  type: integer
                              type: object
                            type: array
                        type: object
                      type: array
                    path:
                      type: string
                    policies:
                      items:
                        description: PolicyReference references a policy by name and
                          an optional namespace.
                        properties:
                          name:
                            type: string
                          namespace:
                            type: string
                        type: object
                      type: array
                    route:
                      type: string
                    splits:
                      items:
                        description: Split defines a split.
                        properties:
                          action:
                            description: Action defines an action.
                            properties:
                              pass:
                                type: string
                              proxy:
                                description: ActionProxy defines a proxy in an Action.
                                properties:
                                  requestHeaders:
                                    description: ProxyRequestHeaders defines the request
                                      headers manipulation in an ActionProxy.
                                    properties:
                                      pass:
                                        type: boolean
                                      set:
                                        items:
                                          description: Header defines an HTTP Header.
                                          properties:
                                            name:
                                              type: string
                                            value:
                                              type: string
                                          type: object
                                        type: array
                                    type: object
                                  responseHeaders:
                                    description: ProxyResponseHeaders defines the
                                      response headers manipulation in an ActionProxy.
                                    properties:
                                      add:
                                        items:
                                          description: AddHeader defines an HTTP Header
                                            with an optional Always field to use with
                                            the add_header NGINX directive.
                                          properties:
                                            always:
                                              type: boolean
                                            name:
                                              type: string
                                            value:
                                              type: string
                                          type: object
                                        type: array
                                      hide:
                                        items:
                                          type: string
                                        type: array
                                      ignore:
                                        items:
                                          type: string
                                        type: array
                                      pass:
                                        items:
                                          type: string
                                        type: array
                                    type: object
                                  rewritePath:
                                    type: string
                                  upstream:
                                    type: string
                                type: object
                              redirect:
                                description: ActionRedirect defines a redirect in
                                  an Action.
                                properties:
                                  code:
                                    type: integer
                                  url:
                                    type: string
                                type: object
                              return:
                                description: ActionReturn defines a return in an Action.
                                properties:
                                  body:
                                    type: string
                                  code:
                                    type: integer
                                  type:
                                    type: string
                                type: object
                            type: object
                          weight:
                            type: integer
                        type: object
                      type: array
                  type: object
                type: array
              server-snippets:
                type: string
              tls:
                description: TLS defines TLS configuration for a VirtualServer.
                properties:
                  cert-manager:
                    description: CertManager defines a cert manager config for a TLS.
                    properties:
                      cluster-issuer:
                        type: string
                      common-name:
                        type: string
                      duration:
                        type: string
                      issue-temp-cert:
                        type: boolean
                      issuer:
                        type: string
                      issuer-group:
                        type: string
                      issuer-kind:
                        type: string
                      renew-before:
                        type: string
                      usages:
                        type: string
                    type: object
                  redirect:
                    description: TLSRedirect defines a redirect for a TLS.
                    properties:
                      basedOn:
                        type: string
                      code:
                        type: integer
                      enable:
                        type: boolean
                    type: object
                  secret:
                    type: string
                type: object
              upstreams:
                items:
                  description: Upstream defines an upstream.
                  properties:
                    backup:
                      type: string
                    backupPort:
                      type: integer
                    buffer-size:
                      type: string
                    buffering:
                      type: boolean
                    buffers:
                      description: UpstreamBuffers defines Buffer Configuration for
                        an Upstream.
                      properties:
                        number:
                          type: integer
                        size:
                          type: string
                      type: object
                    client-max-body-size:
                      type: string
                    connect-timeout:
                      type: string
                    fail-timeout:
                      type: string
                    healthCheck:
                      description: HealthCheck defines the parameters for active Upstream
                        HealthChecks.
                      properties:
                        connect-timeout:
                          type: string
                        enable:
                          type: boolean
                        fails:
                          type: integer
                        grpcService:
                          type: string
                        grpcStatus:
                          type: integer
                        headers:
                          items:
                            description: Header defines an HTTP Header.
                            properties:
                              name:
                                type: string
                              value:
                                type: string
                            type: object
                          type: array
                        interval:
                          type: string
                        jitter:
                          type: string
                        keepalive-time:
                          type: string
                        mandatory:
                          type: boolean
                        passes:
                          type: integer
                        path:
                          type: string
                        persistent:
                          type: boolean
                        port:
                          type: integer
                        read-timeout:
                          type: string
                        send-timeout:
                          type: string
                        statusMatch:
                          type: string
                        tls:
                          description: UpstreamTLS defines a TLS configuration for
                            an Upstream.
                          properties:
                            enable:
                              type: boolean
                          type: object
                      type: object
                    keepalive:
                      type: integer
                    lb-method:
                      type: string
                    max-conns:
                      type: integer
                    max-fails:
                      type: integer
                    name:
                      type: string
                    next-upstream:
                      type: string
                    next-upstream-timeout:
                      type: string
                    next-upstream-tries:
                      type: integer
                    ntlm:
                      type: boolean
                    port:
                      type: integer
                    queue:
                      description: UpstreamQueue defines Queue Configuration for an
                        Upstream.
                      properties:
                        size:
                          type: integer
                        timeout:
                          type: string
                      type: object
                    read-timeout:
                      type: string
                    send-timeout:
                      type: string
                    service:
                      type: string
                    sessionCookie:
                      description: SessionCookie defines the parameters for session
                        persistence.
                      properties:
                        domain:
                          type: string
                        enable:
                          type: boolean
                        expires:
                          type: string
                        httpOnly:
                          type: boolean
                        name:
                          type: string
                        path:
                          type: string
                        samesite:
                          type: string
                        secure:
                          type: boolean
                      type: object
                    slow-start:
                      type: string
                    subselector:
                      additionalProperties:
                        type: string
                      type: object
                    tls:
                      description: UpstreamTLS defines a TLS configuration for an
                        Upstream.
                      properties:
                        enable:
                          type: boolean
                      type: object
                    type:
                      type: string
                    use-cluster-ip:
                      type: boolean
                  type: object
                type: array
            type: object
          status:
            description: VirtualServerStatus defines the status for the VirtualServer
              resource.
            properties:
              externalEndpoints:
                items:
                  description: ExternalEndpoint defines the IP/ Hostname and ports
                    used to connect to this resource.
                  properties:
                    hostname:
                      type: string
                    ip:
                      type: string
                    ports:
                      type: string
                  type: object
                type: array
              message:
                type: string
              reason:
                type: string
              state:
                type: string
            type: object
        type: object
    served: true
    storage: true
    subresources:
      status: {}
YAML
}

resource "kubectl_manifest" "vs_routes" {
    yaml_body = <<YAML

apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  annotations:
    controller-gen.kubebuilder.io/version: v0.15.0
  name: virtualserverroutes.k8s.nginx.org
spec:
  group: k8s.nginx.org
  names:
    kind: VirtualServerRoute
    listKind: VirtualServerRouteList
    plural: virtualserverroutes
    shortNames:
    - vsr
    singular: virtualserverroute
  scope: Namespaced
  versions:
  - additionalPrinterColumns:
    - description: Current state of the VirtualServerRoute. If the resource has a
        valid status, it means it has been validated and accepted by the Ingress Controller.
      jsonPath: .status.state
      name: State
      type: string
    - jsonPath: .spec.host
      name: Host
      type: string
    - jsonPath: .status.externalEndpoints[*].ip
      name: IP
      type: string
    - jsonPath: .status.externalEndpoints[*].hostname
      name: ExternalHostname
      priority: 1
      type: string
    - jsonPath: .status.externalEndpoints[*].ports
      name: Ports
      type: string
    - jsonPath: .metadata.creationTimestamp
      name: Age
      type: date
    name: v1
    schema:
      openAPIV3Schema:
        description: VirtualServerRoute defines the VirtualServerRoute resource.
        properties:
          apiVersion:
            description: |-
              APIVersion defines the versioned schema of this representation of an object.
              Servers should convert recognized schemas to the latest internal value, and
              may reject unrecognized values.
              More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
            type: string
          kind:
            description: |-
              Kind is a string value representing the REST resource this object represents.
              Servers may infer this from the endpoint the client submits requests to.
              Cannot be updated.
              In CamelCase.
              More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
            type: string
          metadata:
            type: object
          spec:
            description: VirtualServerRouteSpec is the spec of the VirtualServerRoute
              resource.
            properties:
              host:
                type: string
              ingressClassName:
                type: string
              subroutes:
                items:
                  description: Route defines a route.
                  properties:
                    action:
                      description: Action defines an action.
                      properties:
                        pass:
                          type: string
                        proxy:
                          description: ActionProxy defines a proxy in an Action.
                          properties:
                            requestHeaders:
                              description: ProxyRequestHeaders defines the request
                                headers manipulation in an ActionProxy.
                              properties:
                                pass:
                                  type: boolean
                                set:
                                  items:
                                    description: Header defines an HTTP Header.
                                    properties:
                                      name:
                                        type: string
                                      value:
                                        type: string
                                    type: object
                                  type: array
                              type: object
                            responseHeaders:
                              description: ProxyResponseHeaders defines the response
                                headers manipulation in an ActionProxy.
                              properties:
                                add:
                                  items:
                                    description: AddHeader defines an HTTP Header
                                      with an optional Always field to use with the
                                      add_header NGINX directive.
                                    properties:
                                      always:
                                        type: boolean
                                      name:
                                        type: string
                                      value:
                                        type: string
                                    type: object
                                  type: array
                                hide:
                                  items:
                                    type: string
                                  type: array
                                ignore:
                                  items:
                                    type: string
                                  type: array
                                pass:
                                  items:
                                    type: string
                                  type: array
                              type: object
                            rewritePath:
                              type: string
                            upstream:
                              type: string
                          type: object
                        redirect:
                          description: ActionRedirect defines a redirect in an Action.
                          properties:
                            code:
                              type: integer
                            url:
                              type: string
                          type: object
                        return:
                          description: ActionReturn defines a return in an Action.
                          properties:
                            body:
                              type: string
                            code:
                              type: integer
                            type:
                              type: string
                          type: object
                      type: object
                    dos:
                      type: string
                    errorPages:
                      items:
                        description: ErrorPage defines an ErrorPage in a Route.
                        properties:
                          codes:
                            items:
                              type: integer
                            type: array
                          redirect:
                            description: ErrorPageRedirect defines a redirect for
                              an ErrorPage.
                            properties:
                              code:
                                type: integer
                              url:
                                type: string
                            type: object
                          return:
                            description: ErrorPageReturn defines a return for an ErrorPage.
                            properties:
                              body:
                                type: string
                              code:
                                type: integer
                              headers:
                                items:
                                  description: Header defines an HTTP Header.
                                  properties:
                                    name:
                                      type: string
                                    value:
                                      type: string
                                  type: object
                                type: array
                              type:
                                type: string
                            type: object
                        type: object
                      type: array
                    location-snippets:
                      type: string
                    matches:
                      items:
                        description: Match defines a match.
                        properties:
                          action:
                            description: Action defines an action.
                            properties:
                              pass:
                                type: string
                              proxy:
                                description: ActionProxy defines a proxy in an Action.
                                properties:
                                  requestHeaders:
                                    description: ProxyRequestHeaders defines the request
                                      headers manipulation in an ActionProxy.
                                    properties:
                                      pass:
                                        type: boolean
                                      set:
                                        items:
                                          description: Header defines an HTTP Header.
                                          properties:
                                            name:
                                              type: string
                                            value:
                                              type: string
                                          type: object
                                        type: array
                                    type: object
                                  responseHeaders:
                                    description: ProxyResponseHeaders defines the
                                      response headers manipulation in an ActionProxy.
                                    properties:
                                      add:
                                        items:
                                          description: AddHeader defines an HTTP Header
                                            with an optional Always field to use with
                                            the add_header NGINX directive.
                                          properties:
                                            always:
                                              type: boolean
                                            name:
                                              type: string
                                            value:
                                              type: string
                                          type: object
                                        type: array
                                      hide:
                                        items:
                                          type: string
                                        type: array
                                      ignore:
                                        items:
                                          type: string
                                        type: array
                                      pass:
                                        items:
                                          type: string
                                        type: array
                                    type: object
                                  rewritePath:
                                    type: string
                                  upstream:
                                    type: string
                                type: object
                              redirect:
                                description: ActionRedirect defines a redirect in
                                  an Action.
                                properties:
                                  code:
                                    type: integer
                                  url:
                                    type: string
                                type: object
                              return:
                                description: ActionReturn defines a return in an Action.
                                properties:
                                  body:
                                    type: string
                                  code:
                                    type: integer
                                  type:
                                    type: string
                                type: object
                            type: object
                          conditions:
                            items:
                              description: Condition defines a condition in a MatchRule.
                              properties:
                                argument:
                                  type: string
                                cookie:
                                  type: string
                                header:
                                  type: string
                                value:
                                  type: string
                                variable:
                                  type: string
                              type: object
                            type: array
                          splits:
                            items:
                              description: Split defines a split.
                              properties:
                                action:
                                  description: Action defines an action.
                                  properties:
                                    pass:
                                      type: string
                                    proxy:
                                      description: ActionProxy defines a proxy in
                                        an Action.
                                      properties:
                                        requestHeaders:
                                          description: ProxyRequestHeaders defines
                                            the request headers manipulation in an
                                            ActionProxy.
                                          properties:
                                            pass:
                                              type: boolean
                                            set:
                                              items:
                                                description: Header defines an HTTP
                                                  Header.
                                                properties:
                                                  name:
                                                    type: string
                                                  value:
                                                    type: string
                                                type: object
                                              type: array
                                          type: object
                                        responseHeaders:
                                          description: ProxyResponseHeaders defines
                                            the response headers manipulation in an
                                            ActionProxy.
                                          properties:
                                            add:
                                              items:
                                                description: AddHeader defines an
                                                  HTTP Header with an optional Always
                                                  field to use with the add_header
                                                  NGINX directive.
                                                properties:
                                                  always:
                                                    type: boolean
                                                  name:
                                                    type: string
                                                  value:
                                                    type: string
                                                type: object
                                              type: array
                                            hide:
                                              items:
                                                type: string
                                              type: array
                                            ignore:
                                              items:
                                                type: string
                                              type: array
                                            pass:
                                              items:
                                                type: string
                                              type: array
                                          type: object
                                        rewritePath:
                                          type: string
                                        upstream:
                                          type: string
                                      type: object
                                    redirect:
                                      description: ActionRedirect defines a redirect
                                        in an Action.
                                      properties:
                                        code:
                                          type: integer
                                        url:
                                          type: string
                                      type: object
                                    return:
                                      description: ActionReturn defines a return in
                                        an Action.
                                      properties:
                                        body:
                                          type: string
                                        code:
                                          type: integer
                                        type:
                                          type: string
                                      type: object
                                  type: object
                                weight:
                                  type: integer
                              type: object
                            type: array
                        type: object
                      type: array
                    path:
                      type: string
                    policies:
                      items:
                        description: PolicyReference references a policy by name and
                          an optional namespace.
                        properties:
                          name:
                            type: string
                          namespace:
                            type: string
                        type: object
                      type: array
                    route:
                      type: string
                    splits:
                      items:
                        description: Split defines a split.
                        properties:
                          action:
                            description: Action defines an action.
                            properties:
                              pass:
                                type: string
                              proxy:
                                description: ActionProxy defines a proxy in an Action.
                                properties:
                                  requestHeaders:
                                    description: ProxyRequestHeaders defines the request
                                      headers manipulation in an ActionProxy.
                                    properties:
                                      pass:
                                        type: boolean
                                      set:
                                        items:
                                          description: Header defines an HTTP Header.
                                          properties:
                                            name:
                                              type: string
                                            value:
                                              type: string
                                          type: object
                                        type: array
                                    type: object
                                  responseHeaders:
                                    description: ProxyResponseHeaders defines the
                                      response headers manipulation in an ActionProxy.
                                    properties:
                                      add:
                                        items:
                                          description: AddHeader defines an HTTP Header
                                            with an optional Always field to use with
                                            the add_header NGINX directive.
                                          properties:
                                            always:
                                              type: boolean
                                            name:
                                              type: string
                                            value:
                                              type: string
                                          type: object
                                        type: array
                                      hide:
                                        items:
                                          type: string
                                        type: array
                                      ignore:
                                        items:
                                          type: string
                                        type: array
                                      pass:
                                        items:
                                          type: string
                                        type: array
                                    type: object
                                  rewritePath:
                                    type: string
                                  upstream:
                                    type: string
                                type: object
                              redirect:
                                description: ActionRedirect defines a redirect in
                                  an Action.
                                properties:
                                  code:
                                    type: integer
                                  url:
                                    type: string
                                type: object
                              return:
                                description: ActionReturn defines a return in an Action.
                                properties:
                                  body:
                                    type: string
                                  code:
                                    type: integer
                                  type:
                                    type: string
                                type: object
                            type: object
                          weight:
                            type: integer
                        type: object
                      type: array
                  type: object
                type: array
              upstreams:
                items:
                  description: Upstream defines an upstream.
                  properties:
                    backup:
                      type: string
                    backupPort:
                      type: integer
                    buffer-size:
                      type: string
                    buffering:
                      type: boolean
                    buffers:
                      description: UpstreamBuffers defines Buffer Configuration for
                        an Upstream.
                      properties:
                        number:
                          type: integer
                        size:
                          type: string
                      type: object
                    client-max-body-size:
                      type: string
                    connect-timeout:
                      type: string
                    fail-timeout:
                      type: string
                    healthCheck:
                      description: HealthCheck defines the parameters for active Upstream
                        HealthChecks.
                      properties:
                        connect-timeout:
                          type: string
                        enable:
                          type: boolean
                        fails:
                          type: integer
                        grpcService:
                          type: string
                        grpcStatus:
                          type: integer
                        headers:
                          items:
                            description: Header defines an HTTP Header.
                            properties:
                              name:
                                type: string
                              value:
                                type: string
                            type: object
                          type: array
                        interval:
                          type: string
                        jitter:
                          type: string
                        keepalive-time:
                          type: string
                        mandatory:
                          type: boolean
                        passes:
                          type: integer
                        path:
                          type: string
                        persistent:
                          type: boolean
                        port:
                          type: integer
                        read-timeout:
                          type: string
                        send-timeout:
                          type: string
                        statusMatch:
                          type: string
                        tls:
                          description: UpstreamTLS defines a TLS configuration for
                            an Upstream.
                          properties:
                            enable:
                              type: boolean
                          type: object
                      type: object
                    keepalive:
                      type: integer
                    lb-method:
                      type: string
                    max-conns:
                      type: integer
                    max-fails:
                      type: integer
                    name:
                      type: string
                    next-upstream:
                      type: string
                    next-upstream-timeout:
                      type: string
                    next-upstream-tries:
                      type: integer
                    ntlm:
                      type: boolean
                    port:
                      type: integer
                    queue:
                      description: UpstreamQueue defines Queue Configuration for an
                        Upstream.
                      properties:
                        size:
                          type: integer
                        timeout:
                          type: string
                      type: object
                    read-timeout:
                      type: string
                    send-timeout:
                      type: string
                    service:
                      type: string
                    sessionCookie:
                      description: SessionCookie defines the parameters for session
                        persistence.
                      properties:
                        domain:
                          type: string
                        enable:
                          type: boolean
                        expires:
                          type: string
                        httpOnly:
                          type: boolean
                        name:
                          type: string
                        path:
                          type: string
                        samesite:
                          type: string
                        secure:
                          type: boolean
                      type: object
                    slow-start:
                      type: string
                    subselector:
                      additionalProperties:
                        type: string
                      type: object
                    tls:
                      description: UpstreamTLS defines a TLS configuration for an
                        Upstream.
                      properties:
                        enable:
                          type: boolean
                      type: object
                    type:
                      type: string
                    use-cluster-ip:
                      type: boolean
                  type: object
                type: array
            type: object
          status:
            description: VirtualServerRouteStatus defines the status for the VirtualServerRoute
              resource.
            properties:
              externalEndpoints:
                items:
                  description: ExternalEndpoint defines the IP/ Hostname and ports
                    used to connect to this resource.
                  properties:
                    hostname:
                      type: string
                    ip:
                      type: string
                    ports:
                      type: string
                  type: object
                type: array
              message:
                type: string
              reason:
                type: string
              referencedBy:
                type: string
              state:
                type: string
            type: object
        type: object
    served: true
    storage: true
    subresources:
      status: {}

YAML
}

resource "kubectl_manifest" "ts" {
    yaml_body = <<YAML

apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  annotations:
    controller-gen.kubebuilder.io/version: v0.15.0
  name: transportservers.k8s.nginx.org
spec:
  group: k8s.nginx.org
  names:
    kind: TransportServer
    listKind: TransportServerList
    plural: transportservers
    shortNames:
    - ts
    singular: transportserver
  scope: Namespaced
  versions:
  - additionalPrinterColumns:
    - description: Current state of the TransportServer. If the resource has a valid
        status, it means it has been validated and accepted by the Ingress Controller.
      jsonPath: .status.state
      name: State
      type: string
    - jsonPath: .status.reason
      name: Reason
      type: string
    - jsonPath: .metadata.creationTimestamp
      name: Age
      type: date
    name: v1
    schema:
      openAPIV3Schema:
        description: TransportServer defines the TransportServer resource.
        properties:
          apiVersion:
            description: |-
              APIVersion defines the versioned schema of this representation of an object.
              Servers should convert recognized schemas to the latest internal value, and
              may reject unrecognized values.
              More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
            type: string
          kind:
            description: |-
              Kind is a string value representing the REST resource this object represents.
              Servers may infer this from the endpoint the client submits requests to.
              Cannot be updated.
              In CamelCase.
              More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
            type: string
          metadata:
            type: object
          spec:
            description: TransportServerSpec is the spec of the TransportServer resource.
            properties:
              action:
                description: TransportServerAction defines an action.
                properties:
                  pass:
                    type: string
                type: object
              host:
                type: string
              ingressClassName:
                type: string
              listener:
                description: TransportServerListener defines a listener for a TransportServer.
                properties:
                  name:
                    type: string
                  protocol:
                    type: string
                type: object
              serverSnippets:
                type: string
              sessionParameters:
                description: SessionParameters defines session parameters.
                properties:
                  timeout:
                    type: string
                type: object
              streamSnippets:
                type: string
              tls:
                description: TransportServerTLS defines TransportServerTLS configuration
                  for a TransportServer.
                properties:
                  secret:
                    type: string
                type: object
              upstreamParameters:
                description: UpstreamParameters defines parameters for an upstream.
                properties:
                  connectTimeout:
                    type: string
                  nextUpstream:
                    type: boolean
                  nextUpstreamTimeout:
                    type: string
                  nextUpstreamTries:
                    type: integer
                  udpRequests:
                    type: integer
                  udpResponses:
                    type: integer
                type: object
              upstreams:
                items:
                  description: TransportServerUpstream defines an upstream.
                  properties:
                    backup:
                      type: string
                    backupPort:
                      type: integer
                    failTimeout:
                      type: string
                    healthCheck:
                      description: TransportServerHealthCheck defines the parameters
                        for active Upstream HealthChecks.
                      properties:
                        enable:
                          type: boolean
                        fails:
                          type: integer
                        interval:
                          type: string
                        jitter:
                          type: string
                        match:
                          description: TransportServerMatch defines the parameters
                            of a custom health check.
                          properties:
                            expect:
                              type: string
                            send:
                              type: string
                          type: object
                        passes:
                          type: integer
                        port:
                          type: integer
                        timeout:
                          type: string
                      type: object
                    loadBalancingMethod:
                      type: string
                    maxConns:
                      type: integer
                    maxFails:
                      type: integer
                    name:
                      type: string
                    port:
                      type: integer
                    service:
                      type: string
                  type: object
                type: array
            type: object
          status:
            description: TransportServerStatus defines the status for the TransportServer
              resource.
            properties:
              message:
                type: string
              reason:
                type: string
              state:
                type: string
            type: object
        type: object
    served: true
    storage: true
    subresources:
      status: {}
  - additionalPrinterColumns:
    - description: Current state of the TransportServer. If the resource has a valid
        status, it means it has been validated and accepted by the Ingress Controller.
      jsonPath: .status.state
      name: State
      type: string
    - jsonPath: .status.reason
      name: Reason
      type: string
    - jsonPath: .metadata.creationTimestamp
      name: Age
      type: date
    name: v1alpha1
    schema:
      openAPIV3Schema:
        description: TransportServer defines the TransportServer resource.
        properties:
          apiVersion:
            description: |-
              APIVersion defines the versioned schema of this representation of an object.
              Servers should convert recognized schemas to the latest internal value, and
              may reject unrecognized values.
              More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
            type: string
          kind:
            description: |-
              Kind is a string value representing the REST resource this object represents.
              Servers may infer this from the endpoint the client submits requests to.
              Cannot be updated.
              In CamelCase.
              More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
            type: string
          metadata:
            type: object
          spec:
            description: TransportServerSpec is the spec of the TransportServer resource.
            properties:
              action:
                description: TransportServerAction defines an action.
                properties:
                  pass:
                    type: string
                type: object
              host:
                type: string
              ingressClassName:
                type: string
              listener:
                description: TransportServerListener defines a listener for a TransportServer.
                properties:
                  name:
                    type: string
                  protocol:
                    type: string
                type: object
              serverSnippets:
                type: string
              sessionParameters:
                description: SessionParameters defines session parameters.
                properties:
                  timeout:
                    type: string
                type: object
              streamSnippets:
                type: string
              tls:
                description: TransportServerTLS defines TransportServerTLS configuration
                  for a TransportServer.
                properties:
                  secret:
                    type: string
                type: object
              upstreamParameters:
                description: UpstreamParameters defines parameters for an upstream.
                properties:
                  connectTimeout:
                    type: string
                  nextUpstream:
                    type: boolean
                  nextUpstreamTimeout:
                    type: string
                  nextUpstreamTries:
                    type: integer
                  udpRequests:
                    type: integer
                  udpResponses:
                    type: integer
                type: object
              upstreams:
                items:
                  description: TransportServerUpstream defines an upstream.
                  properties:
                    backup:
                      type: string
                    backupPort:
                      type: integer
                    failTimeout:
                      type: string
                    healthCheck:
                      description: TransportServerHealthCheck defines the parameters
                        for active Upstream HealthChecks.
                      properties:
                        enable:
                          type: boolean
                        fails:
                          type: integer
                        interval:
                          type: string
                        jitter:
                          type: string
                        match:
                          description: TransportServerMatch defines the parameters
                            of a custom health check.
                          properties:
                            expect:
                              type: string
                            send:
                              type: string
                          type: object
                        passes:
                          type: integer
                        port:
                          type: integer
                        timeout:
                          type: string
                      type: object
                    loadBalancingMethod:
                      type: string
                    maxConns:
                      type: integer
                    maxFails:
                      type: integer
                    name:
                      type: string
                    port:
                      type: integer
                    service:
                      type: string
                  type: object
                type: array
            type: object
          status:
            description: TransportServerStatus defines the status for the TransportServer
              resource.
            properties:
              message:
                type: string
              reason:
                type: string
              state:
                type: string
            type: object
        type: object
    served: true
    storage: false
    subresources:
      status: {}

YAML
}

resource "kubectl_manifest" "org-policies" {
    yaml_body = <<YAML

apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  annotations:
    controller-gen.kubebuilder.io/version: v0.15.0
  name: policies.k8s.nginx.org
spec:
  group: k8s.nginx.org
  names:
    kind: Policy
    listKind: PolicyList
    plural: policies
    shortNames:
    - pol
    singular: policy
  scope: Namespaced
  versions:
  - additionalPrinterColumns:
    - description: Current state of the Policy. If the resource has a valid status,
        it means it has been validated and accepted by the Ingress Controller.
      jsonPath: .status.state
      name: State
      type: string
    - jsonPath: .metadata.creationTimestamp
      name: Age
      type: date
    name: v1
    schema:
      openAPIV3Schema:
        description: Policy defines a Policy for VirtualServer and VirtualServerRoute
          resources.
        properties:
          apiVersion:
            description: |-
              APIVersion defines the versioned schema of this representation of an object.
              Servers should convert recognized schemas to the latest internal value, and
              may reject unrecognized values.
              More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
            type: string
          kind:
            description: |-
              Kind is a string value representing the REST resource this object represents.
              Servers may infer this from the endpoint the client submits requests to.
              Cannot be updated.
              In CamelCase.
              More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
            type: string
          metadata:
            type: object
          spec:
            description: |-
              PolicySpec is the spec of the Policy resource.
              The spec includes multiple fields, where each field represents a different policy.
              Only one policy (field) is allowed.
            properties:
              accessControl:
                description: AccessControl defines an access policy based on the source
                  IP of a request.
                properties:
                  allow:
                    items:
                      type: string
                    type: array
                  deny:
                    items:
                      type: string
                    type: array
                type: object
              basicAuth:
                description: |-
                  BasicAuth holds HTTP Basic authentication configuration
                  policy status: preview
                properties:
                  realm:
                    type: string
                  secret:
                    type: string
                type: object
              egressMTLS:
                description: EgressMTLS defines an Egress MTLS policy.
                properties:
                  ciphers:
                    type: string
                  protocols:
                    type: string
                  serverName:
                    type: boolean
                  sessionReuse:
                    type: boolean
                  sslName:
                    type: string
                  tlsSecret:
                    type: string
                  trustedCertSecret:
                    type: string
                  verifyDepth:
                    type: integer
                  verifyServer:
                    type: boolean
                type: object
              ingressClassName:
                type: string
              ingressMTLS:
                description: IngressMTLS defines an Ingress MTLS policy.
                properties:
                  clientCertSecret:
                    type: string
                  crlFileName:
                    type: string
                  verifyClient:
                    type: string
                  verifyDepth:
                    type: integer
                type: object
              jwt:
                description: JWTAuth holds JWT authentication configuration.
                properties:
                  jwksURI:
                    type: string
                  keyCache:
                    type: string
                  realm:
                    type: string
                  secret:
                    type: string
                  token:
                    type: string
                type: object
              oidc:
                description: OIDC defines an Open ID Connect policy.
                properties:
                  accessTokenEnable:
                    type: boolean
                  authEndpoint:
                    type: string
                  authExtraArgs:
                    items:
                      type: string
                    type: array
                  clientID:
                    type: string
                  clientSecret:
                    type: string
                  jwksURI:
                    type: string
                  redirectURI:
                    type: string
                  scope:
                    type: string
                  tokenEndpoint:
                    type: string
                  zoneSyncLeeway:
                    type: integer
                type: object
              rateLimit:
                description: RateLimit defines a rate limit policy.
                properties:
                  burst:
                    type: integer
                  delay:
                    type: integer
                  dryRun:
                    type: boolean
                  key:
                    type: string
                  logLevel:
                    type: string
                  noDelay:
                    type: boolean
                  rate:
                    type: string
                  rejectCode:
                    type: integer
                  zoneSize:
                    type: string
                type: object
              waf:
                description: WAF defines an WAF policy.
                properties:
                  apBundle:
                    type: string
                  apPolicy:
                    type: string
                  enable:
                    type: boolean
                  securityLog:
                    description: SecurityLog defines the security log of a WAF policy.
                    properties:
                      apLogBundle:
                        type: string
                      apLogConf:
                        type: string
                      enable:
                        type: boolean
                      logDest:
                        type: string
                    type: object
                  securityLogs:
                    items:
                      description: SecurityLog defines the security log of a WAF policy.
                      properties:
                        apLogBundle:
                          type: string
                        apLogConf:
                          type: string
                        enable:
                          type: boolean
                        logDest:
                          type: string
                      type: object
                    type: array
                type: object
            type: object
          status:
            description: PolicyStatus is the status of the policy resource
            properties:
              message:
                type: string
              reason:
                type: string
              state:
                type: string
            type: object
        type: object
    served: true
    storage: true
    subresources:
      status: {}
  - name: v1alpha1
    schema:
      openAPIV3Schema:
        description: Policy defines a Policy for VirtualServer and VirtualServerRoute
          resources.
        properties:
          apiVersion:
            description: |-
              APIVersion defines the versioned schema of this representation of an object.
              Servers should convert recognized schemas to the latest internal value, and
              may reject unrecognized values.
              More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
            type: string
          kind:
            description: |-
              Kind is a string value representing the REST resource this object represents.
              Servers may infer this from the endpoint the client submits requests to.
              Cannot be updated.
              In CamelCase.
              More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
            type: string
          metadata:
            type: object
          spec:
            description: |-
              PolicySpec is the spec of the Policy resource.
              The spec includes multiple fields, where each field represents a different policy.
              Only one policy (field) is allowed.
            properties:
              accessControl:
                description: AccessControl defines an access policy based on the source
                  IP of a request.
                properties:
                  allow:
                    items:
                      type: string
                    type: array
                  deny:
                    items:
                      type: string
                    type: array
                type: object
              egressMTLS:
                description: EgressMTLS defines an Egress MTLS policy.
                properties:
                  ciphers:
                    type: string
                  protocols:
                    type: string
                  serverName:
                    type: boolean
                  sessionReuse:
                    type: boolean
                  sslName:
                    type: string
                  tlsSecret:
                    type: string
                  trustedCertSecret:
                    type: string
                  verifyDepth:
                    type: integer
                  verifyServer:
                    type: boolean
                type: object
              ingressMTLS:
                description: IngressMTLS defines an Ingress MTLS policy.
                properties:
                  clientCertSecret:
                    type: string
                  verifyClient:
                    type: string
                  verifyDepth:
                    type: integer
                type: object
              jwt:
                description: JWTAuth holds JWT authentication configuration.
                properties:
                  realm:
                    type: string
                  secret:
                    type: string
                  token:
                    type: string
                type: object
              rateLimit:
                description: RateLimit defines a rate limit policy.
                properties:
                  burst:
                    type: integer
                  delay:
                    type: integer
                  dryRun:
                    type: boolean
                  key:
                    type: string
                  logLevel:
                    type: string
                  noDelay:
                    type: boolean
                  rate:
                    type: string
                  rejectCode:
                    type: integer
                  zoneSize:
                    type: string
                type: object
            type: object
        type: object
    served: true
    storage: false

YAML
}

resource "kubectl_manifest" "org-global-config" {
    yaml_body = <<YAML

apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  annotations:
    controller-gen.kubebuilder.io/version: v0.15.0
  name: globalconfigurations.k8s.nginx.org
spec:
  group: k8s.nginx.org
  names:
    kind: GlobalConfiguration
    listKind: GlobalConfigurationList
    plural: globalconfigurations
    shortNames:
    - gc
    singular: globalconfiguration
  scope: Namespaced
  versions:
  - name: v1
    schema:
      openAPIV3Schema:
        description: GlobalConfiguration defines the GlobalConfiguration resource.
        properties:
          apiVersion:
            description: |-
              APIVersion defines the versioned schema of this representation of an object.
              Servers should convert recognized schemas to the latest internal value, and
              may reject unrecognized values.
              More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
            type: string
          kind:
            description: |-
              Kind is a string value representing the REST resource this object represents.
              Servers may infer this from the endpoint the client submits requests to.
              Cannot be updated.
              In CamelCase.
              More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
            type: string
          metadata:
            type: object
          spec:
            description: GlobalConfigurationSpec is the spec of the GlobalConfiguration
              resource.
            properties:
              listeners:
                items:
                  description: Listener defines a listener.
                  properties:
                    name:
                      type: string
                    port:
                      type: integer
                    protocol:
                      type: string
                    ssl:
                      type: boolean
                  type: object
                type: array
            type: object
        type: object
    served: true
    storage: true
  - name: v1alpha1
    schema:
      openAPIV3Schema:
        description: GlobalConfiguration defines the GlobalConfiguration resource.
        properties:
          apiVersion:
            description: |-
              APIVersion defines the versioned schema of this representation of an object.
              Servers should convert recognized schemas to the latest internal value, and
              may reject unrecognized values.
              More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
            type: string
          kind:
            description: |-
              Kind is a string value representing the REST resource this object represents.
              Servers may infer this from the endpoint the client submits requests to.
              Cannot be updated.
              In CamelCase.
              More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
            type: string
          metadata:
            type: object
          spec:
            description: GlobalConfigurationSpec is the spec of the GlobalConfiguration
              resource.
            properties:
              listeners:
                items:
                  description: Listener defines a listener.
                  properties:
                    name:
                      type: string
                    port:
                      type: integer
                    protocol:
                      type: string
                    ssl:
                      type: boolean
                  type: object
                type: array
            type: object
        type: object
    served: true
    storage: false

YAML
}