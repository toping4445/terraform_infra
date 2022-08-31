resource "helm_release" "karpenter" {
  namespace        = "karpenter"
  create_namespace = true

  name       = "karpenter"
  repository = "https://charts.karpenter.sh"
  chart      = "karpenter"
  version    = "v0.14.0"

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "arn:aws:iam::688339442457:role/karpenter-controller-${local.config.cluster_name}"
  }

  set {
    name  = "clusterName"
    value = local.config.cluster_name
  }

  set {
    name  = "clusterEndpoint"
    value = local.config.cluster_endpoint
  }

  set {
    name  = "aws.defaultInstanceProfile"
    value = "KarpenterNodeInstanceProfile-${local.config.cluster_name}"
  }
}

resource "kubectl_manifest" "karpenter_provisioner" {
  yaml_body = <<-YAML
  apiVersion: karpenter.sh/v1alpha5
  kind: Provisioner
  metadata:
    name: worker
    namespace: karpenter
  spec:
    labels:
      nodeType: worker
    requirements:
      - key: "karpenter.sh/capacity-type"
        operator: In
        values: ["on-demand"]
      - key: "kubernetes.io/arch"
        operator: In
        values: ["amd64"]
      - key: "node.kubernetes.io/instance-type"
        operator: In
        values: ["m5.large"]
      - key: "topology.kubernetes.io/zone"
        operator: In
        values: ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"]
    provider:
      metadataOptions:
        httpTokens: optional
        httpEndpoint: enabled
      blockDeviceMappings:
        - deviceName: /dev/xvda
          ebs:
            volumeSize: 30Gi
            volumeType: gp3
            iops: 3000
            deleteOnTermination: true
            throughput: 125
      instanceProfile: KarpenterNodeInstanceProfile-${local.config.cluster_name}
      subnetSelector:
        karpenter.sh/discovery: ${local.config.cluster_name}
      securityGroupSelector:
        karpenter.sh/discovery: ${local.config.cluster_name}
      tags:
        karpenter.sh/discovery: ${local.config.cluster_name}
    ttlSecondsAfterEmpty: 30
  YAML

  depends_on = [
    helm_release.karpenter
  ]
}
