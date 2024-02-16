variable "nginx-replicas" {
  description = "nginx replicas of the deployment"
  type        = number
  default     = 2
}

variable "nginx-namespace" {
  description = "nginx namespace"
  type        = string
  default     = "default"
}
