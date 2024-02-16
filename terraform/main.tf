provider "kubernetes" {
  config_context = "minikube"
  config_path    = var.kubeconfig
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig
  }
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

module "helm" {
  source         = "./submodules/helm"
  helm-namespace = var.namespace
}


output "api-status" {
  value = module.api.api-deployment-status
}

output "nginx-tf-id" {
  value = module.nginx.nginx-id
}
