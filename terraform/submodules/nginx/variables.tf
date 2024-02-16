variable "nginx-namespace" {
  description = "nginx namespace"
  type        = string
  default     = "default"
}

variable "nginx-replicas" {
  description = "nginx replicas"
  type        = number
  default     = 1
}
