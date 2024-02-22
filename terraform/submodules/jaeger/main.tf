resource "helm_release" "opentelemetry" {
  name = "jaeger-backend"

  chart      = "jaegertracing"
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
