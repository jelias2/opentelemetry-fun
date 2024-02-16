variable "kubeconfig" {
  default     = "~/.kube/config"
  type        = string
  description = "path to kubeconfig"
}

# vars.tfvars
variable "namespace" {
  description = "Namespace for minikube"
  type        = string
  default     = "dev"
}

