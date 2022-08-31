resource "helm_release" "argocd" {
  namespace        = "argo"
  create_namespace = true

  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "4.10.8"

  set {
    name  = "server.extraArgs[0]"
    value = "--insecure"
  }

  set {
    name  = "controller.nodeSelector.nodeType"
    value = "worker"
  }

  set {
    name  = "dex.nodeSelector.nodeType"
    value = "worker"
  }

  set {
    name  = "redis.nodeSelector.nodeType"
    value = "worker"
  }

  set {
    name  = "server.nodeSelector.nodeType"
    value = "worker"
  }

  set {
    name  = "repoServer.nodeSelector.nodeType"
    value = "worker"
  }

  set {
    name  = "applicationSet.nodeSelector.nodeType"
    value = "worker"
  }

  set {
    name  = "notifications.nodeSelector.nodeType"
    value = "worker"
  }
}

resource "kubectl_manifest" "ingress-argocd-server" {
  yaml_body = <<-YAML
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argocd-server
  namespace: argo
  labels:
    app.kubernetes.io/name: argocd
  annotations:
    nginx.ingress.kubernetes.io/force-ssl-redirect: "false"
    nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
spec:
  ingressClassName: nginx
  rules:
    - host: argocd.latte.live
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: argo-cd-argocd-server
                port:
                  number: 80
  YAML

  depends_on = [helm_release.argocd]
}
