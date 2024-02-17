resource "helm_release" "kube-prometheus-stack" {
  name = "kube-prometheus-stack"

  chart      = "kube-prometheus-stack"
  repository = "prometheus-community"
  namespace  = var.helm-namespace

  set {
    name  = "namespaceOverride"
    value = var.helm-namespace
  }
  set {
    name  = "prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues"
    value = false
  }
  set {
    name  = "prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues"
    value = false
  }
}

# + apiVersion = "monitoring.coreos.com/v1"
# + kind       = "ServiceMonitor"
# + metadata   = {
#     + annotations                = (known after apply)
#     + clusterName                = (known after apply)
#     + creationTimestamp          = (known after apply)
#     + deletionGracePeriodSeconds = (known after apply)
#     + deletionTimestamp          = (known after apply)
#     + finalizers                 = (known after apply)
#     + generateName               = (known after apply)
#     + generation                 = (known after apply)
#     + labels                     = (known after apply)
#     + managedFields              = (known after apply)
#     + name                       = "legal-api-service-monitor"
#     + namespace                  = "dev"
#     + ownerReferences            = (known after apply)
#     + resourceVersion            = (known after apply)
#     + selfLink                   = (known after apply)
#     + uid                        = (known after apply)
#   }
# + spec       = {
#     + attachMetadata        = {
#         + node = (known after apply)
#       }
#     + endpoints             = (known after apply)
#     + jobLabel              = (known after apply)
#     + keepDroppedTargets    = (known after apply)
#     + labelLimit            = (known after apply)
#     + labelNameLengthLimit  = (known after apply)
#     + labelValueLengthLimit = (known after apply)
#     + namespaceSelector     = {
#         + any        = (known after apply)
#         + matchNames = (known after apply)
#       }
#     + podTargetLabels       = (known after apply)
#     + sampleLimit           = (known after apply)
#     + selector              = {
#         + matchExpressions = (known after apply)
#         + matchLabels      = {
#             + app         = "api"
#             + provisioner = "terraform"
#           }
#       }
#     + targetLabels          = (known after apply)
#     + targetLimit           = (known after apply)
#   }

resource "kubernetes_manifest" "service-monitor" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "legal-api-service-monitor"
      namespace = var.helm-namespace
      labels = {
        app         = "kube-prometheus-stack-prometheus"
        chart       = "kube-prometheus-stack-56.6.2"
        heritage    = "Helm"
        release     = "kube-prometheus-stack"
        app         = "api"
        provisioner = "terraform"
      }
    }
    spec = {
      endpoints = [{
        port   = "web"
        path   = "/metrics"
        scheme = "http"
      }]
      jobLabel = "legal-api-job"
      selector = {
        matchLabels = {
          app         = "api"
          provisioner = "terraform"
        }
      }
    }
  }
}

resource "kubernetes_manifest" "pod-monitor" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "PodMonitor"
    metadata = {
      name      = "legal-api-pod-monitor"
      namespace = var.helm-namespace
      labels = {
        app         = "kube-prometheus-stack-prometheus"
        chart       = "kube-prometheus-stack-56.6.2"
        heritage    = "Helm"
        release     = "kube-prometheus-stack"
        app         = "api"
        provisioner = "terraform"
      }
    }
    spec = {
      jobLabel = "legal-api-pod-job"
      selector = {
        matchLabels = {
          app         = "api"
          provisioner = "terraform"
        }
      }
      podMetricsEndpoints = [{
        port   = "web"
        path   = "/metrics"
        scheme = "http"
      }]
    }
  }
}



# kind: PodMonitor
# metadata:
#   name: example-app
#   labels:
#     team: frontend
# spec:
#   selector:
#     matchLabels:
#       app: example-app
#   podMetricsEndpoints:
#   - port: web
# /// Endpoints list object
# [check "- authorization:
#     credentials:
#       key: some_key
#       name: credential_name
#       optional: true
#     type: some_type
#   basicAuth:
#     password:
#       key: some_password_key
#       name: password_name
#       optional: true
#     username:
#       key: some_username_key
#       name: username_name
#       optional: true
#   bearerTokenFile: some_file_path
#   bearerTokenSecret:
#     key: token_key
#     name: token_name
#     optional: true
#   enableHttp2: true
#   filterRunning: true
#   followRedirects: true
#   honorLabels: true
#   honorTimestamps: true
#   interval: some_interval
#   metricRelabelings:
#     - action: some_action
#       modulus: 1
#       regex: some_regex
#       replacement: some_replacement
#       separator: some_separator
#       sourceLabels:
#         - label1
#         - label2
#       targetLabel: target_label
#   oauth2:
#     clientId:
#       configMap:
#         key: config_map_key
#         name: config_map_name
#         optional: true
#       secret:
#         key: secret_key
#         name: secret_name
#         optional: true
#     clientSecret:
#       key: client_secret_key
#       name: client_secret_name
#       optional: true
#     endpointParams:
#       param1: value1
#       param2: value2
#     scopes:
#       - scope1
#       - scope2
#     tokenUrl: some_url
#   params:
#     - param1
#     - param2
#   path: some_path
#   port: some_port
#   proxyUrl: some_proxy_url
#   relabelings:
#     - action: some_action
#       modulus: 1
#       regex: some_regex
#       replacement: some_replacement
#       separator: some_separator
#       sourceLabels:
#         - label1
#         - label2
#       targetLabel: target_label
#   scheme: some_scheme
#   scrapeTimeout: some_timeout
#   targetPort: some_target_port
#   tlsConfig:
#     ca:
#       configMap:
#         key: ca_config_map_key
#         name: ca_config_map_name
#         optional: true
#       secret:
#         key: ca_secret_key
#         name: ca_secret_name
#         optional: true
#     caFile: ca_file_path
#     cert:
#       configMap:
#         key: cert_config_map_key
#         name: cert_config_map_name
#         optional: true
#       secret:
#         key: cert_secret_key
#         name: cert_secret_name
#         optional: true
#     certFile: cert_file_path
#     insecureSkipVerify: true
#     keyFile: key_file_path
#     keySecret:
#       key: key_secret_key
#       name: key_secret_name
#       optional: true
#     serverName: some_server_name
#   trackTimestampsStaleness: true
# }]
