resource "kubernetes_deployment" "example" {
  metadata {
    name      = "api-deployment"
    namespace = var.api-namespace
    labels = {
      app         = "api"
      provisioner = "terraform"
    }
  }

  spec {
    replicas = var.api-replicas
    selector {
      match_labels = {
        app         = "api"
        provisioner = "terraform"
      }
    }

    template {
      metadata {
        labels = {
          app         = "api"
          provisioner = "terraform"
        }
      }

      spec {
        container {
          image = "us-central1-docker.pkg.dev/workspace-406820/legal-api-container-repo/legal-term-api:use-tempo-url"
          name  = "legal-api"
          port {
            name           = "web"
            container_port = 8000
          }
          env {
            name  = "TEMPO_URL"
            value = "http://opentelemetry-collector.dev.svc.cluster.local:4318"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "example" {
  metadata {
    name      = "api-service"
    namespace = var.api-namespace
    labels = {
      app         = "api"
      provisioner = "terraform"
    }
  }

  spec {
    selector = {
      app         = "api"
      provisioner = "terraform"
    }

    port {
      name        = "web"
      port        = 8000
      target_port = 8000
    }
  }
}
