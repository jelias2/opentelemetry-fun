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


module "submodule" {
  source          = "./submodules/nginx"
  nginx-replicas  = 2
  nginx-namespace = var.namespace
}
