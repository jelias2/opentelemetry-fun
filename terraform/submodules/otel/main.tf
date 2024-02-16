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
