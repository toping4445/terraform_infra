resource "helm_release" "nginx-controller" {
  namespace        = "ingress-nginx"
  create_namespace = true

  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.2.0"

  set {
    name  = "controller.ingressClassResource.name"
    value = "nginx"
  }

  set {
    name  = "controller.ingressClass"
    value = "nginx"
  }

  set {
    name  = "controller.service.type"
    value = "NodePort"
  }

  set {
    name  = "controller.service.nodePorts.http"
    value = "30080"
  }

  set {
    name  = "controller.service.nodePorts.https"
    value = "30443"
  }

  set {
    name  = "controller.nodeSelector.nodeType"
    value = "worker"
  }

  set {
    name  = "controller.admissionWebhooks.patch.nodeSelector.nodeType"
    value = "worker"
  }

  set {
    name  = "controller.replicaCount"
    value = "3"
  }

  set {
    name  = "controller.topologySpreadConstraints[0].maxSkew"
    value = "1"
  }

  set {
    name  = "controller.topologySpreadConstraints[0].topologyKey"
    value = "topology.kubernetes.io/zone"
  }

  set {
    name  = "controller.topologySpreadConstraints[0].whenUnsatisfiable"
    value = "ScheduleAnyway"
  }

  set {
    name  = "controller.topologySpreadConstraints[0].labelSelector.matchLabels.app\\.kubernetes\\.io/name"
    value = "ingress-nginx"
  }

  set {
    name  = "controller.resources.limits.cpu"
    value = "500m"
  }

  set {
    name  = "controller.resources.limits.memory"
    value = "500Mi"
  }
}
