variable "api-replicas" {
  description = "api replicas of the deployment"
  type        = number
  default     = 2
}

variable "api-namespace" {
  description = "api namespace"
  type        = string
  default     = "default"
}
