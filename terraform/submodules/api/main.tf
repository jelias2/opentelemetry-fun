resource "kubernetes_deployment" "example" {
  metadata {
    name      = "api-deployment"
    namespace = var.api-namespace
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
          image = "us-central1-docker.pkg.dev/workspace-406820/legal-api-container-repo/legal-term-api:monitor"
          name  = "api-container"
          port {
            container_port = 8000
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
  }

  spec {
    selector = {
      app = kubernetes_deployment.example.spec[0].template[0].metadata[0].labels.app
    }

    port {
      port        = 8000
      target_port = 8000
    }
  }
}
