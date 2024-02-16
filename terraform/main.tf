provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minikube"
}

# vars.tfvars
variable "namespace" {
  description = "Namespace for minikube"
  type        = string
  default     = "dev"
}

variable "replicas" {
  description = "replicas of the deployment"
  type        = number
  default     = 3
}


resource "kubernetes_namespace" "example" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_deployment" "example" {
  metadata {
    name      = "nginx-deployment"
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "example"
      }
    }

    template {
      metadata {
        labels = {
          app         = "example"
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
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  spec {
    selector = {
      app = kubernetes_deployment.example.spec[0].template[0].metadata[0].labels.app
    }

    port {
      port        = 80
      target_port = 80
    }
  }
}

