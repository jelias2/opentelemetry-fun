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

resource "kubernetes_namespace" "example" {
  metadata {
    name = var.namespace
  }
}


module "nginx" {
  source          = "./submodules/nginx"
  nginx-replicas  = 2
  nginx-namespace = var.namespace
}

module "api" {
  source        = "./submodules/api"
  api-replicas  = 1
  api-namespace = var.namespace
}


output "api-status" {
  value = module.api.api-deployment-status
}

output "nginx-tf-id" {
  value = module.nginx.nginx-id
}
