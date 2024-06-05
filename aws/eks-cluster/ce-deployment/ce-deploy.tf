resource "kubectl_manifest" "ns" {
    yaml_body = <<YAML
apiVersion: v1
kind: Namespace
metadata:
  name: ves-system
YAML
}

resource "kubectl_manifest" "sa" {
    depends_on = [kubectl_manifest.ns]
    yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  name: volterra-sa
  namespace: ves-system
YAML
}


resource "kubectl_manifest" "role" {
    depends_on = [kubectl_manifest.ns]
    yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: volterra-admin-role
  namespace: ves-system
rules:
- apiGroups: ["*"]
  resources: ["*"]
  verbs: ["*"]
YAML
}

resource "kubectl_manifest" "role-binding" {
    depends_on = [kubectl_manifest.ns]
    yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: volterra-admin-role-binding
  namespace: ves-system
subjects:
- kind: ServiceAccount
  name: volterra-sa
  apiGroup: ""
  namespace: ves-system
roleRef:
  kind: Role
  name: volterra-admin-role
  apiGroup: rbac.authorization.k8s.io
YAML
}


resource "kubectl_manifest" "daemonset" {
    depends_on = [kubectl_manifest.ns]
    yaml_body = <<YAML
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: volterra-ce-init
  namespace: ves-system
spec:
  selector:
    matchLabels:
      name: volterra-ce-init
  template:
    metadata:
      labels:
        name: volterra-ce-init
    spec:
      hostNetwork: true
      hostPID: true
      serviceAccountName: volterra-sa
      containers:
      - name: volterra-ce-init
        image: gcr.io/volterraio/volterra-ce-init
        volumeMounts:
        - name: hostroot
          mountPath: /host
        securityContext:
          privileged: true
      volumes:
      - name: hostroot
        hostPath:
          path: /
YAML
}


resource "kubectl_manifest" "sa2" {
    depends_on = [kubectl_manifest.ns]
    yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  name: vpm-sa
  namespace: ves-system
YAML
}

resource "kubectl_manifest" "role2" {
    depends_on = [kubectl_manifest.ns]
    yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: vpm-role
  namespace: ves-system
rules:
- apiGroups: ["*"]
  resources: ["*"]
  verbs: ["*"]
YAML
}

resource "kubectl_manifest" "cluster-role" {
    depends_on = [kubectl_manifest.ns]
    yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: vpm-cluster-role
  namespace: ves-system
rules:
- apiGroups: [""]
  resources: ["nodes"]
  verbs: ["get", "list"]
YAML
}

resource "kubectl_manifest" "role-binding2" {
    depends_on = [kubectl_manifest.ns]
    yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: vpm-role-binding
  namespace: ves-system
subjects:
- kind: ServiceAccount
  name: vpm-sa
  apiGroup: ""
  namespace: ves-system
roleRef:
  kind: Role
  name: vpm-role
  apiGroup: rbac.authorization.k8s.io
YAML
}


resource "kubectl_manifest" "ClusterRoleBinding" {
    depends_on = [kubectl_manifest.ns]
    yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: vpm-sa
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: vpm-cluster-role
subjects:
- kind: ServiceAccount
  name: vpm-sa
  namespace: ves-system
YAML
}


resource "kubectl_manifest" "ClusterRoleBinding2" {
    depends_on = [kubectl_manifest.ns]
    yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: ver
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: ver
  namespace: ves-system
YAML
}



resource "kubectl_manifest" "StatefulSet" {
    depends_on = [kubectl_manifest.ns]
    yaml_body = <<YAML
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: vp-manager
  namespace: ves-system
spec:
  replicas: 1
  selector:
    matchLabels:
      name: vpm
  serviceName: "vp-manager"
  template:
    metadata:
      labels:
        name: vpm
        statefulset: vp-manager
    spec:
      serviceAccountName: vpm-sa
      affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchExpressions:
              - key: name
                operator: In
                values:
                - vpm
            topologyKey: kubernetes.io/hostname
      initContainers:
      - name : vpm-init-config
        image: busybox
        volumeMounts:
        - name: etcvpm
          mountPath: /etc/vpm
        - name: vpmconfigmap
          mountPath: /tmp/config.yaml
          subPath: config.yaml
        command:
        - "/bin/sh"
        - "-c"
        - "cp /tmp/config.yaml /etc/vpm"
      containers:
      - name: vp-manager
        image: gcr.io/volterraio/vpm
        imagePullPolicy: Always
        volumeMounts:
        - name: etcvpm
          mountPath: /etc/vpm
        - name: varvpm
          mountPath: /var/lib/vpm
        - name: podinfo
          mountPath: /etc/podinfo
        - name: data
          mountPath: /data
        securityContext:
          privileged: true
      terminationGracePeriodSeconds: 1
      volumes:
      - name: podinfo
        downwardAPI:
          items:
            - path: "labels"
              fieldRef:
                fieldPath: metadata.labels
      - name: vpmconfigmap
        configMap:
          name: vpm-cfg
  volumeClaimTemplates:
  - metadata:
      name: etcvpm
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 1Gi
  - metadata:
      name: varvpm
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 1Gi
  - metadata:
      name: data
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 1Gi
YAML
}


resource "kubectl_manifest" "service" {
    depends_on = [kubectl_manifest.ns]
    yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  name: vpm
  namespace: ves-system
spec:
  type: NodePort
  selector:
    name: vpm
  ports:
  - protocol: TCP
    port: 65003
    targetPort: 65003
YAML
}
