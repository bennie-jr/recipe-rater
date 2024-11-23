# Install ArgoCD Helm chart
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "5.36.7"
  namespace        = var.argo_namespace
  create_namespace = true

  wait          = true
  wait_for_jobs = true

  values = [file("${path.module}/values/argocd-values.yaml")]
}
