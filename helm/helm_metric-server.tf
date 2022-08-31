resource "helm_release" "metrics-server" {
  namespace        = "kube-system"
  create_namespace = false

  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version    = "3.8.0"

  set {
    name  = "nodeSelector.nodeType"
    value = "worker"
  }
}
