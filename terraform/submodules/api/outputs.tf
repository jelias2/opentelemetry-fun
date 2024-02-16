output "api-deployment-status" {
  value = kubernetes_deployment.example.wait_for_rollout
}
