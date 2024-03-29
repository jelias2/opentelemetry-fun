resource "helm_release" "opentelemetry" {
  name = "opentelemetry-collector"

  chart      = "opentelemetry-collector"
  repository = "open-telemetry"

  set {
    name  = "namespaceOverride"
    value = var.helm-namespace
  }
  set {
    name  = "mode"
    value = "deployment"
  }
}

## Use grafana jaeger data source: jaeger-query.dev.svc.cluster.local:80
