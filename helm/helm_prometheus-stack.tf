resource "helm_release" "prometheus-stack" {
  namespace        = "monitoring"
  create_namespace = true

  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "36.1.0"


  set {
    name  = "alertmanagerSpec.nodeSelector.nodeType"
    value = "worker"
  }

  set {
    name  = "grafana.adminUser"
    value = "admin"
  }

  set {
    name  = "grafana.adminPassword"
    value = "awsdna4team3"
  }

  set {
    name  = "grafana.ingress.enabled"
    value = "true"
  }

  set {
    name  = "grafana.ingress.ingressClassName"
    value = "nginx"
  }

  set {
    name  = "grafana.ingress.path"
    value = "/"
  }

#  set {
#    name  = "grafana.plugins[0]"
#    value = "pixie-pixie-datasource"
#  }

  set {
    name  = "grafana.ingress.hosts[0]"
    value = "grafana.latte.live"
  }

  set {
    name  = "grafana.nodeSelector.nodeType"
    value = "worker"
  }

  set {
    name  = "prometheusOperator.nodeSelector.nodeType"
    value = "worker"
  }

  set {
    name  = "prometheusSpec.nodeSelector.nodeType"
    value = "worker"
  }

  set {
    name  = "kube-state-metrics.nodeSelector.nodeType"
    value = "worker"
  }
}
