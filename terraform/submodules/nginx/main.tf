resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = "nginx-deployment"
    namespace = var.nginx-namespace
  }

  spec {
    replicas = var.nginx-replicas

    selector {
      match_labels = {
        app         = "nginx"
        provisioner = "terraform"
      }
    }

    template {
      metadata {
        labels = {
          app         = "nginx"
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

resource "kubernetes_service" "nginx-service" {
  metadata {
    name      = "nginx-service"
    namespace = var.nginx-namespace
  }

  spec {
    selector = {
      app         = "nginx"
      provisioner = "terraform"
    }

    port {
      port        = 80
      target_port = 8000
    }
  }
}
