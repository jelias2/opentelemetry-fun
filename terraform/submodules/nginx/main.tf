resource "kubernetes_deployment" "example" {
  metadata {
    name      = "nginx-deployment"
    namespace = var.nginx-namespace
  }

  spec {
    replicas = var.nginx-replicas

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
          image = "nginx:latest"
          name  = "nginx-container"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "example" {
  metadata {
    name      = "example-service"
    namespace = var.nginx-namespace
  }

  spec {
    selector = {
      app = kubernetes_deployment.example.spec[0].template[0].metadata[0].labels.app
    }

    port {
      port        = 80
      target_port = 8000
    }
  }
}