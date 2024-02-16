resource "helm_release" "kube-prometheus-stack" {
  name = "kube-prometheus-stack"

  chart      = "kube-prometheus-stack"
  repository = "prometheus-community"

  set {
    name  = "namespaceOverride"
    value = var.helm-namespace
  }
}

resource "kubernetes_manifest" "service-monitor" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "legal-api-service-monitor"
      namespace = var.helm-namespace
    }
    spec = {
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
