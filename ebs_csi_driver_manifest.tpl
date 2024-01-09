---
# Source: aws-ebs-csi-driver/templates/poddisruptionbudget-controller.yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: ebs-csi-controller
  namespace: kube-system
  labels:
    app.kubernetes.io/name: aws-ebs-csi-driver
    app.kubernetes.io/instance: aws-ebs-csi-driver
    helm.sh/chart: aws-ebs-csi-driver-2.20.0
    app.kubernetes.io/version: "1.20.0"
    app.kubernetes.io/component: csi-driver
    app.kubernetes.io/managed-by: Helm
spec:
  selector:
    matchLabels:
      app: ebs-csi-controller
      app.kubernetes.io/name: aws-ebs-csi-driver
      app.kubernetes.io/instance: aws-ebs-csi-driver
  maxUnavailable: 1
---
# Source: aws-ebs-csi-driver/templates/serviceaccount-csi-controller.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: ebs-csi-controller-sa
  namespace: kube-system
  labels:
    app.kubernetes.io/name: aws-ebs-csi-driver
    app.kubernetes.io/instance: aws-ebs-csi-driver
    helm.sh/chart: aws-ebs-csi-driver-2.20.0
    app.kubernetes.io/version: "1.20.0"
    app.kubernetes.io/component: csi-driver
    app.kubernetes.io/managed-by: Helm
  annotations:
    eks.amazonaws.com/role-arn: ${role_arn}
automountServiceAccountToken: true
---
# Source: aws-ebs-csi-driver/templates/serviceaccount-csi-node.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: ebs-csi-node-sa
  namespace: kube-system
  labels:
    app.kubernetes.io/name: aws-ebs-csi-driver
    app.kubernetes.io/instance: aws-ebs-csi-driver
    helm.sh/chart: aws-ebs-csi-driver-2.20.0
    app.kubernetes.io/version: "1.20.0"
    app.kubernetes.io/component: csi-driver
    app.kubernetes.io/managed-by: Helm
automountServiceAccountToken: true
---
# Source: aws-ebs-csi-driver/templates/clusterrole-attacher.yaml
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: ebs-external-attacher-role
  labels:
    app.kubernetes.io/name: aws-ebs-csi-driver
    app.kubernetes.io/instance: aws-ebs-csi-driver
    helm.sh/chart: aws-ebs-csi-driver-2.20.0
    app.kubernetes.io/version: "1.20.0"
    app.kubernetes.io/component: csi-driver
    app.kubernetes.io/managed-by: Helm
rules:
  - apiGroups: [ "" ]
    resources: [ "persistentvolumes" ]
    verbs: [ "get", "list", "watch", "update", "patch" ]
  - apiGroups: [ "" ]
    resources: [ "nodes" ]
    verbs: [ "get", "list", "watch" ]
  - apiGroups: [ "csi.storage.k8s.io" ]
    resources: [ "csinodeinfos" ]
    verbs: [ "get", "list", "watch" ]
  - apiGroups: [ "storage.k8s.io" ]
    resources: [ "volumeattachments" ]
    verbs: [ "get", "list", "watch", "update", "patch" ]
  - apiGroups: [ "storage.k8s.io" ]
    resources: [ "volumeattachments/status" ]
    verbs: [ "patch" ]
---
# Source: aws-ebs-csi-driver/templates/clusterrole-csi-node.yaml
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: ebs-csi-node-role
  labels:
    app.kubernetes.io/name: aws-ebs-csi-driver
    app.kubernetes.io/instance: aws-ebs-csi-driver
    helm.sh/chart: aws-ebs-csi-driver-2.20.0
    app.kubernetes.io/version: "1.20.0"
    app.kubernetes.io/component: csi-driver
    app.kubernetes.io/managed-by: Helm
rules:
  - apiGroups: [""]
    resources: ["nodes"]
    verbs: ["get", "patch"]
---
# Source: aws-ebs-csi-driver/templates/clusterrole-provisioner.yaml
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: ebs-external-provisioner-role
  labels:
    app.kubernetes.io/name: aws-ebs-csi-driver
    app.kubernetes.io/instance: aws-ebs-csi-driver
    helm.sh/chart: aws-ebs-csi-driver-2.20.0
    app.kubernetes.io/version: "1.20.0"
    app.kubernetes.io/component: csi-driver
    app.kubernetes.io/managed-by: Helm
rules:
  - apiGroups: [ "" ]
    resources: [ "persistentvolumes" ]
    verbs: [ "get", "list", "watch", "create", "delete" ]
  - apiGroups: [ "" ]
    resources: [ "persistentvolumeclaims" ]
    verbs: [ "get", "list", "watch", "update" ]
  - apiGroups: [ "storage.k8s.io" ]
    resources: [ "storageclasses" ]
    verbs: [ "get", "list", "watch" ]
  - apiGroups: [ "" ]
    resources: [ "events" ]
    verbs: [ "list", "watch", "create", "update", "patch" ]
  - apiGroups: [ "snapshot.storage.k8s.io" ]
    resources: [ "volumesnapshots" ]
    verbs: [ "get", "list" ]
  - apiGroups: [ "snapshot.storage.k8s.io" ]
    resources: [ "volumesnapshotcontents" ]
    verbs: [ "get", "list" ]
  - apiGroups: [ "storage.k8s.io" ]
    resources: [ "csinodes" ]
    verbs: [ "get", "list", "watch" ]
  - apiGroups: [ "" ]
    resources: [ "nodes" ]
    verbs: [ "get", "list", "watch" ]
  - apiGroups: [ "storage.k8s.io" ]
    resources: [ "volumeattachments" ]
    verbs: [ "get", "list", "watch" ]
---
# Source: aws-ebs-csi-driver/templates/clusterrole-resizer.yaml
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: ebs-external-resizer-role
  labels:
    app.kubernetes.io/name: aws-ebs-csi-driver
    app.kubernetes.io/instance: aws-ebs-csi-driver
    helm.sh/chart: aws-ebs-csi-driver-2.20.0
    app.kubernetes.io/version: "1.20.0"
    app.kubernetes.io/component: csi-driver
    app.kubernetes.io/managed-by: Helm
rules:
  # The following rule should be uncommented for plugins that require secrets
  # for provisioning.
  # - apiGroups: [""]
  #   resources: ["secrets"]
  #   verbs: ["get", "list", "watch"]
  - apiGroups: [ "" ]
    resources: [ "persistentvolumes" ]
    verbs: [ "get", "list", "watch", "update", "patch" ]
  - apiGroups: [ "" ]
    resources: [ "persistentvolumeclaims" ]
    verbs: [ "get", "list", "watch" ]
  - apiGroups: [ "" ]
    resources: [ "persistentvolumeclaims/status" ]
    verbs: [ "update", "patch" ]
  - apiGroups: [ "storage.k8s.io" ]
    resources: [ "storageclasses" ]
    verbs: [ "get", "list", "watch" ]
  - apiGroups: [ "" ]
    resources: [ "events" ]
    verbs: [ "list", "watch", "create", "update", "patch" ]
  - apiGroups: [ "" ]
    resources: [ "pods" ]
    verbs: [ "get", "list", "watch" ]
---
# Source: aws-ebs-csi-driver/templates/clusterrole-snapshotter.yaml
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: ebs-external-snapshotter-role
  labels:
    app.kubernetes.io/name: aws-ebs-csi-driver
    app.kubernetes.io/instance: aws-ebs-csi-driver
    helm.sh/chart: aws-ebs-csi-driver-2.20.0
    app.kubernetes.io/version: "1.20.0"
    app.kubernetes.io/component: csi-driver
    app.kubernetes.io/managed-by: Helm
rules:
  - apiGroups: [ "" ]
    resources: [ "events" ]
    verbs: [ "list", "watch", "create", "update", "patch" ]
  # Secret permission is optional.
  # Enable it if your driver needs secret.
  # For example, `csi.storage.k8s.io/snapshotter-secret-name` is set in VolumeSnapshotClass.
  # See https://kubernetes-csi.github.io/docs/secrets-and-credentials.html for more details.
  # - apiGroups: [ "" ]
  #   resources: [ "secrets" ]
  #   verbs: [ "get", "list" ]
  - apiGroups: [ "snapshot.storage.k8s.io" ]
    resources: [ "volumesnapshotclasses" ]
    verbs: [ "get", "list", "watch" ]
  - apiGroups: [ "snapshot.storage.k8s.io" ]
    resources: [ "volumesnapshotcontents" ]
    verbs: [ "create", "get", "list", "watch", "update", "delete", "patch" ]
  - apiGroups: [ "snapshot.storage.k8s.io" ]
    resources: [ "volumesnapshotcontents/status" ]
    verbs: [ "update" ]
---
# Source: aws-ebs-csi-driver/templates/clusterrolebinding-attacher.yaml
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: ebs-csi-attacher-binding
  labels:
    app.kubernetes.io/name: aws-ebs-csi-driver
    app.kubernetes.io/instance: aws-ebs-csi-driver
    helm.sh/chart: aws-ebs-csi-driver-2.20.0
    app.kubernetes.io/version: "1.20.0"
    app.kubernetes.io/component: csi-driver
    app.kubernetes.io/managed-by: Helm
subjects:
  - kind: ServiceAccount
    name: ebs-csi-controller-sa
    namespace: kube-system
roleRef:
  kind: ClusterRole
  name: ebs-external-attacher-role
  apiGroup: rbac.authorization.k8s.io
---
# Source: aws-ebs-csi-driver/templates/clusterrolebinding-csi-node.yaml
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: ebs-csi-node-getter-binding
  labels:
    app.kubernetes.io/name: aws-ebs-csi-driver
    app.kubernetes.io/instance: aws-ebs-csi-driver
    helm.sh/chart: aws-ebs-csi-driver-2.20.0
    app.kubernetes.io/version: "1.20.0"
    app.kubernetes.io/component: csi-driver
    app.kubernetes.io/managed-by: Helm
subjects:
  - kind: ServiceAccount
    name: ebs-csi-node-sa
    namespace: kube-system
roleRef:
  kind: ClusterRole
  name: ebs-csi-node-role
  apiGroup: rbac.authorization.k8s.io
---
# Source: aws-ebs-csi-driver/templates/clusterrolebinding-provisioner.yaml
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: ebs-csi-provisioner-binding
  labels:
    app.kubernetes.io/name: aws-ebs-csi-driver
    app.kubernetes.io/instance: aws-ebs-csi-driver
    helm.sh/chart: aws-ebs-csi-driver-2.20.0
    app.kubernetes.io/version: "1.20.0"
    app.kubernetes.io/component: csi-driver
    app.kubernetes.io/managed-by: Helm
subjects:
  - kind: ServiceAccount
    name: ebs-csi-controller-sa
    namespace: kube-system
roleRef:
  kind: ClusterRole
  name: ebs-external-provisioner-role
  apiGroup: rbac.authorization.k8s.io
---
# Source: aws-ebs-csi-driver/templates/clusterrolebinding-resizer.yaml
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: ebs-csi-resizer-binding
  labels:
    app.kubernetes.io/name: aws-ebs-csi-driver
    app.kubernetes.io/instance: aws-ebs-csi-driver
    helm.sh/chart: aws-ebs-csi-driver-2.20.0
    app.kubernetes.io/version: "1.20.0"
    app.kubernetes.io/component: csi-driver
    app.kubernetes.io/managed-by: Helm
subjects:
  - kind: ServiceAccount
    name: ebs-csi-controller-sa
    namespace: kube-system
roleRef:
  kind: ClusterRole
  name: ebs-external-resizer-role
  apiGroup: rbac.authorization.k8s.io
---
# Source: aws-ebs-csi-driver/templates/clusterrolebinding-snapshotter.yaml
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: ebs-csi-snapshotter-binding
  labels:
    app.kubernetes.io/name: aws-ebs-csi-driver
    app.kubernetes.io/instance: aws-ebs-csi-driver
    helm.sh/chart: aws-ebs-csi-driver-2.20.0
    app.kubernetes.io/version: "1.20.0"
    app.kubernetes.io/component: csi-driver
    app.kubernetes.io/managed-by: Helm
subjects:
  - kind: ServiceAccount
    name: ebs-csi-controller-sa
    namespace: kube-system
roleRef:
  kind: ClusterRole
  name: ebs-external-snapshotter-role
  apiGroup: rbac.authorization.k8s.io
---
# Source: aws-ebs-csi-driver/templates/role-leases.yaml
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: kube-system
  name: ebs-csi-leases-role
rules:
  - apiGroups: ["coordination.k8s.io"]
    resources: ["leases"]
    verbs: ["get", "watch", "list", "delete", "update", "create"]
---
# Source: aws-ebs-csi-driver/templates/rolebinding-leases.yaml
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: ebs-csi-leases-rolebinding
  namespace: kube-system
  labels:
    app.kubernetes.io/name: aws-ebs-csi-driver
    app.kubernetes.io/instance: aws-ebs-csi-driver
    helm.sh/chart: aws-ebs-csi-driver-2.20.0
    app.kubernetes.io/version: "1.20.0"
    app.kubernetes.io/component: csi-driver
    app.kubernetes.io/managed-by: Helm
subjects:
  - kind: ServiceAccount
    name: ebs-csi-controller-sa
    namespace: kube-system
roleRef:
  kind: Role
  name: ebs-csi-leases-role
  apiGroup: rbac.authorization.k8s.io
---
# Source: aws-ebs-csi-driver/templates/node.yaml
# Node Service
kind: DaemonSet
apiVersion: apps/v1
metadata:
  name: ebs-csi-node
  namespace: kube-system
  labels:
    app.kubernetes.io/name: aws-ebs-csi-driver
    app.kubernetes.io/instance: aws-ebs-csi-driver
    helm.sh/chart: aws-ebs-csi-driver-2.20.0
    app.kubernetes.io/version: "1.20.0"
    app.kubernetes.io/component: csi-driver
    app.kubernetes.io/managed-by: Helm
spec:
  selector:
    matchLabels:
      app: ebs-csi-node
      app.kubernetes.io/name: aws-ebs-csi-driver
      app.kubernetes.io/instance: aws-ebs-csi-driver
  updateStrategy:
    rollingUpdate:
      maxUnavailable: 10%
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: ebs-csi-node
        app.kubernetes.io/name: aws-ebs-csi-driver
        app.kubernetes.io/instance: aws-ebs-csi-driver
        helm.sh/chart: aws-ebs-csi-driver-2.20.0
        app.kubernetes.io/version: "1.20.0"
        app.kubernetes.io/component: csi-driver
        app.kubernetes.io/managed-by: Helm
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
              - matchExpressions:
                  - key: eks.amazonaws.com/compute-type
                    operator: NotIn
                    values:
                      - fargate
      nodeSelector:
        kubernetes.io/os: linux
      serviceAccountName: ebs-csi-node-sa
      priorityClassName: system-node-critical
      tolerations:
        - operator: Exists
      securityContext:
        fsGroup: 0
        runAsGroup: 0
        runAsNonRoot: false
        runAsUser: 0
      containers:
        - name: ebs-plugin
          image: public.ecr.aws/ebs-csi-driver/aws-ebs-csi-driver:v1.20.0
          imagePullPolicy: IfNotPresent
          args:
            - node
            - --endpoint=$(CSI_ENDPOINT)
            - --logging-format=text
            - --v=2
          env:
            - name: CSI_ENDPOINT
              value: unix:/csi/csi.sock
            - name: CSI_NODE_NAME
              valueFrom:
                fieldRef:
                  fieldPath: spec.nodeName
          volumeMounts:
            - name: kubelet-dir
              mountPath: /var/lib/kubelet
              mountPropagation: "Bidirectional"
            - name: plugin-dir
              mountPath: /csi
            - name: device-dir
              mountPath: /dev
          ports:
            - name: healthz
              containerPort: 9808
              protocol: TCP
          livenessProbe:
            httpGet:
              path: /healthz
              port: healthz
            initialDelaySeconds: 10
            timeoutSeconds: 3
            periodSeconds: 10
            failureThreshold: 5
          resources:
            limits:
              cpu: 200m
              memory: 200Mi
            requests:
              cpu: 5m
              memory: 10Mi
          securityContext:
            privileged: true
            readOnlyRootFilesystem: true
        - name: node-driver-registrar
          image: public.ecr.aws/eks-distro/kubernetes-csi/node-driver-registrar:v2.8.0-eks-1-27-3
          imagePullPolicy: IfNotPresent
          args:
            - --csi-address=$(ADDRESS)
            - --kubelet-registration-path=$(DRIVER_REG_SOCK_PATH)
            - --v=2
          env:
            - name: ADDRESS
              value: /csi/csi.sock
            - name: DRIVER_REG_SOCK_PATH
              value: /var/lib/kubelet/plugins/ebs.csi.aws.com/csi.sock
          livenessProbe:
            exec:
              command:
                - /csi-node-driver-registrar
                - --kubelet-registration-path=$(DRIVER_REG_SOCK_PATH)
                - --mode=kubelet-registration-probe
            initialDelaySeconds: 30
            timeoutSeconds: 15
            periodSeconds: 90
          volumeMounts:
            - name: plugin-dir
              mountPath: /csi
            - name: registration-dir
              mountPath: /registration
            - name: probe-dir
              mountPath: /var/lib/kubelet/plugins/ebs.csi.aws.com/
          resources:
            limits:
              cpu: 200m
              memory: 20Mi
            requests:
              cpu: 5m
              memory: 10Mi
          securityContext:
            allowPrivilegeEscalation: false
            readOnlyRootFilesystem: true
        - name: liveness-probe
          image: public.ecr.aws/eks-distro/kubernetes-csi/livenessprobe:v2.10.0-eks-1-27-3
          imagePullPolicy: IfNotPresent
          args:
            - --csi-address=/csi/csi.sock
          volumeMounts:
            - name: plugin-dir
              mountPath: /csi
          resources:
            limits:
              cpu: 200m
              memory: 20Mi
            requests:
              cpu: 5m
              memory: 10Mi
          securityContext:
            allowPrivilegeEscalation: false
            readOnlyRootFilesystem: true
      volumes:
        - name: kubelet-dir
          hostPath:
            path: /var/lib/kubelet
            type: Directory
        - name: plugin-dir
          hostPath:
            path: /var/lib/kubelet/plugins/ebs.csi.aws.com/
            type: DirectoryOrCreate
        - name: registration-dir
          hostPath:
            path: /var/lib/kubelet/plugins_registry/
            type: Directory
        - name: device-dir
          hostPath:
            path: /dev
            type: Directory
        - name: probe-dir
          emptyDir: {}
---
# Source: aws-ebs-csi-driver/templates/controller.yaml
# Controller Service
kind: Deployment
apiVersion: apps/v1
metadata:
  name: ebs-csi-controller
  namespace: kube-system
  labels:
    app.kubernetes.io/name: aws-ebs-csi-driver
    app.kubernetes.io/instance: aws-ebs-csi-driver
    helm.sh/chart: aws-ebs-csi-driver-2.20.0
    app.kubernetes.io/version: "1.20.0"
    app.kubernetes.io/component: csi-driver
    app.kubernetes.io/managed-by: Helm
spec:
  replicas: 2
  strategy:
    rollingUpdate:
      maxUnavailable: 1
    type: RollingUpdate
  selector:
    matchLabels:
      app: ebs-csi-controller
      app.kubernetes.io/name: aws-ebs-csi-driver
      app.kubernetes.io/instance: aws-ebs-csi-driver
  template:
    metadata:
      labels:
        app: ebs-csi-controller
        app.kubernetes.io/name: aws-ebs-csi-driver
        app.kubernetes.io/instance: aws-ebs-csi-driver
        helm.sh/chart: aws-ebs-csi-driver-2.20.0
        app.kubernetes.io/version: "1.20.0"
        app.kubernetes.io/component: csi-driver
        app.kubernetes.io/managed-by: Helm
    spec:
      nodeSelector:
        kubernetes.io/os: linux
      serviceAccountName: ebs-csi-controller-sa
      priorityClassName: system-cluster-critical
      affinity:
        nodeAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
            - preference:
                matchExpressions:
                  - key: eks.amazonaws.com/compute-type
                    operator: NotIn
                    values:
                      - fargate
              weight: 1
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
            - podAffinityTerm:
                labelSelector:
                  matchExpressions:
                    - key: app
                      operator: In
                      values:
                        - ebs-csi-controller
                topologyKey: kubernetes.io/hostname
              weight: 100
      tolerations:
        - key: CriticalAddonsOnly
          operator: Exists
        - effect: NoExecute
          operator: Exists
          tolerationSeconds: 300
      securityContext:
        fsGroup: 1000
        runAsGroup: 1000
        runAsNonRoot: true
        runAsUser: 1000
      containers:
        - name: ebs-plugin
          image: public.ecr.aws/ebs-csi-driver/aws-ebs-csi-driver:v1.20.0
          imagePullPolicy: IfNotPresent
          args:
            - controller
            - --endpoint=$(CSI_ENDPOINT)
            - --extra-tags=${tags}
            - --k8s-tag-cluster-id=${cluster_id}
            - --logging-format=text
            - --user-agent-extra=helm
            - --v=5
          env:
            - name: CSI_ENDPOINT
              value: unix:///var/lib/csi/sockets/pluginproxy/csi.sock
            - name: CSI_NODE_NAME
              valueFrom:
                fieldRef:
                  fieldPath: spec.nodeName
            - name: AWS_ACCESS_KEY_ID
              valueFrom:
                secretKeyRef:
                  name: aws-secret
                  key: key_id
                  optional: true
            - name: AWS_SECRET_ACCESS_KEY
              valueFrom:
                secretKeyRef:
                  name: aws-secret
                  key: access_key
                  optional: true
            - name: AWS_EC2_ENDPOINT
              valueFrom:
                configMapKeyRef:
                  name: aws-meta
                  key: endpoint
                  optional: true
          volumeMounts:
            - name: socket-dir
              mountPath: /var/lib/csi/sockets/pluginproxy/
          ports:
            - name: healthz
              containerPort: 9808
              protocol: TCP
          livenessProbe:
            httpGet:
              path: /healthz
              port: healthz
            initialDelaySeconds: 10
            timeoutSeconds: 3
            periodSeconds: 10
            failureThreshold: 5
          readinessProbe:
            httpGet:
              path: /healthz
              port: healthz
            initialDelaySeconds: 10
            timeoutSeconds: 3
            periodSeconds: 10
            failureThreshold: 5
          resources:
            limits:
              cpu: 200m
              memory: 200Mi
            requests:
              cpu: 5m
              memory: 10Mi
          securityContext:
            allowPrivilegeEscalation: false
            readOnlyRootFilesystem: true
        - name: csi-provisioner
          image: public.ecr.aws/eks-distro/kubernetes-csi/external-provisioner:v3.5.0-eks-1-27-3
          imagePullPolicy: IfNotPresent
          args:
            - --csi-address=$(ADDRESS)
            - --v=2
            - --feature-gates=Topology=true
            - --extra-create-metadata
            - --leader-election=true
            - --default-fstype=ext4
          env:
            - name: ADDRESS
              value: /var/lib/csi/sockets/pluginproxy/csi.sock
          volumeMounts:
            - name: socket-dir
              mountPath: /var/lib/csi/sockets/pluginproxy/
          resources:
            limits:
              cpu: 200m
              memory: 20Mi
            requests:
              cpu: 5m
              memory: 10Mi
          securityContext:
            allowPrivilegeEscalation: false
            readOnlyRootFilesystem: true
        - name: csi-attacher
          image: public.ecr.aws/eks-distro/kubernetes-csi/external-attacher:v4.3.0-eks-1-27-3
          imagePullPolicy: IfNotPresent
          args:
            - --csi-address=$(ADDRESS)
            - --v=2
            - --leader-election=true
          env:
            - name: ADDRESS
              value: /var/lib/csi/sockets/pluginproxy/csi.sock
          volumeMounts:
            - name: socket-dir
              mountPath: /var/lib/csi/sockets/pluginproxy/
          resources:
            limits:
              cpu: 200m
              memory: 20Mi
            requests:
              cpu: 5m
              memory: 10Mi
          securityContext:
            allowPrivilegeEscalation: false
            readOnlyRootFilesystem: true
        - name: csi-snapshotter
          image: public.ecr.aws/eks-distro/kubernetes-csi/external-snapshotter/csi-snapshotter:v6.2.1-eks-1-27-3
          imagePullPolicy: IfNotPresent
          args:
            - --csi-address=$(ADDRESS)
            - --leader-election=true
            - --extra-create-metadata
          env:
            - name: ADDRESS
              value: /var/lib/csi/sockets/pluginproxy/csi.sock
          volumeMounts:
            - name: socket-dir
              mountPath: /var/lib/csi/sockets/pluginproxy/
          resources:
            limits:
              cpu: 200m
              memory: 20Mi
            requests:
              cpu: 5m
              memory: 10Mi
          securityContext:
            allowPrivilegeEscalation: false
            readOnlyRootFilesystem: true
        - name: csi-resizer
          image: public.ecr.aws/eks-distro/kubernetes-csi/external-resizer:v1.8.0-eks-1-27-3
          imagePullPolicy: IfNotPresent
          args:
            - --csi-address=$(ADDRESS)
            - --v=2
            - --handle-volume-inuse-error=false
            - --leader-election=true
          env:
            - name: ADDRESS
              value: /var/lib/csi/sockets/pluginproxy/csi.sock
          volumeMounts:
            - name: socket-dir
              mountPath: /var/lib/csi/sockets/pluginproxy/
          resources:
            limits:
              cpu: 200m
              memory: 50Mi
            requests:
              cpu: 5m
              memory: 10Mi
          securityContext:
            allowPrivilegeEscalation: false
            readOnlyRootFilesystem: true
        - name: liveness-probe
          image: public.ecr.aws/eks-distro/kubernetes-csi/livenessprobe:v2.10.0-eks-1-27-3
          imagePullPolicy: IfNotPresent
          args:
            - --csi-address=/csi/csi.sock
          volumeMounts:
            - name: socket-dir
              mountPath: /csi
          resources:
            limits:
              cpu: 200m
              memory: 20Mi
            requests:
              cpu: 5m
              memory: 10Mi
          securityContext:
            allowPrivilegeEscalation: false
            readOnlyRootFilesystem: true
      volumes:
        - name: socket-dir
          emptyDir: {}
---
# Source: aws-ebs-csi-driver/templates/csidriver.yaml
apiVersion: storage.k8s.io/v1
kind: CSIDriver
metadata:
  name: ebs.csi.aws.com
  labels:
    app.kubernetes.io/name: aws-ebs-csi-driver
    app.kubernetes.io/instance: aws-ebs-csi-driver
    helm.sh/chart: aws-ebs-csi-driver-2.20.0
    app.kubernetes.io/version: "1.20.0"
    app.kubernetes.io/component: csi-driver
    app.kubernetes.io/managed-by: Helm
spec:
  attachRequired: true
  podInfoOnMount: false
  # Commented out due to
  #   CSIDriver.storage.k8s.io "ebs.csi.aws.com" is invalid: spec.fsGroupPolicy: Invalid value: "File": field is immutable
  # fsGroupPolicy: File
