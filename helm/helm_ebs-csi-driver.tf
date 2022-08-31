module "ebs-csi-driver-irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.0.0"

  role_name = "ebs-csi-driver"

  role_policy_arns = {
    ebs-csi-driver = aws_iam_policy.ebs-csi-driver.arn
  }

  oidc_providers = {
    ex = {
      provider_arn               = local.config.oidc_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
}

resource "aws_iam_policy" "ebs-csi-driver" {
  name   = "ebs-csi-driver"
  policy = <<-EOF
{
    "Statement": [
        {
            "Action": [
                "ec2:CreateSnapshot",
                "ec2:AttachVolume",
                "ec2:DetachVolume",
                "ec2:ModifyVolume",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeInstances",
                "ec2:DescribeSnapshots",
                "ec2:DescribeTags",
                "ec2:DescribeVolumes",
                "ec2:DescribeVolumesModifications"
            ],
            "Effect": "Allow",
            "Resource": [
                "*"
            ]
        },
        {
            "Action": [
                "ec2:CreateTags"
            ],
            "Condition": {
                "StringEquals": {
                    "ec2:CreateAction": [
                        "CreateVolume",
                        "CreateSnapshot"
                    ]
                }
            },
            "Effect": "Allow",
            "Resource": [
                "arn:aws:ec2:*:*:volume/*",
                "arn:aws:ec2:*:*:snapshot/*"
            ]
        },
        {
            "Action": [
                "ec2:DeleteTags"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:ec2:*:*:volume/*",
                "arn:aws:ec2:*:*:snapshot/*"
            ]
        },
        {
            "Action": [
                "ec2:CreateVolume"
            ],
            "Condition": {
                "StringLike": {
                    "aws:RequestTag/ebs.csi.aws.com/cluster": "true"
                }
            },
            "Effect": "Allow",
            "Resource": [
                "*"
            ]
        },
        {
            "Action": [
                "ec2:CreateVolume"
            ],
            "Condition": {
                "StringLike": {
                    "aws:RequestTag/CSIVolumeName": "*"
                }
            },
            "Effect": "Allow",
            "Resource": [
                "*"
            ]
        },
        {
            "Action": [
                "ec2:CreateVolume"
            ],
            "Condition": {
                "StringLike": {
                    "aws:RequestTag/kubernetes.io/cluster/*": "owned"
                }
            },
            "Effect": "Allow",
            "Resource": [
                "*"
            ]
        },
        {
            "Action": [
                "ec2:DeleteVolume"
            ],
            "Condition": {
                "StringLike": {
                    "aws:RequestTag/ebs.csi.aws.com/cluster": "true"
                }
            },
            "Effect": "Allow",
            "Resource": [
                "*"
            ]
        },
        {
            "Action": [
                "ec2:DeleteVolume"
            ],
            "Condition": {
                "StringLike": {
                    "aws:RequestTag/CSIVolumeName": "*"
                }
            },
            "Effect": "Allow",
            "Resource": [
                "*"
            ]
        },
        {
            "Action": [
                "ec2:DeleteVolume"
            ],
            "Condition": {
                "StringLike": {
                    "aws:RequestTag/kubernetes.io/cluster/*": "owned"
                }
            },
            "Effect": "Allow",
            "Resource": [
                "*"
            ]
        },
        {
            "Action": [
                "ec2:DeleteSnapshot"
            ],
            "Condition": {
                "StringLike": {
                    "ec2:ResourceTag/CSIVolumeSnapshotName": "*"
                }
            },
            "Effect": "Allow",
            "Resource": [
                "*"
            ]
        },
        {
            "Action": [
                "ec2:DeleteSnapshot"
            ],
            "Condition": {
                "StringLike": {
                    "ec2:ResourceTag/ebs.csi.aws.com/cluster": "true"
                }
            },
            "Effect": "Allow",
            "Resource": [
                "*"
            ]
        }
    ],
    "Version": "2012-10-17"
}
  EOF
}

resource "helm_release" "ebs-csi-driver" {
  namespace        = "kube-system"
  create_namespace = false

  name       = "aws-ebs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"
  version    = "2.6.7"

  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.ap-northeast-2.amazonaws.com/eks/aws-ebs-csi-driver"
  }

  set {
    name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "arn:aws:iam::688339442457:role/ebs-csi-driver"
  }

  set {
    name  = "controller.securityContext.fsGroup"
    value = "65534"
  }

  set {
    name  = "node.tolerateAllTaints"
    value = "true"
  }

  set {
    name  = "storageClasses[0].name"
    value = "gp3"
  }

  set {
    name  = "storageClasses[0].annotations.storageclass\\.kubernetes\\.io/is-default-class"
    type = "string"
    value = "true"
  }

  set {
    name  = "storageClasses[0].volumeBindingMode"
    value = "WaitForFirstConsumer"
  }

  set {
    name  = "storageClasses[0].reclaimPolicy"
    value = "Delete"
  }

  set {
    name  = "storageClasses[0].allowVolumeExpansion"
    value = "true"
  }

  set {
    name  = "storageClasses[0].parameters.type"
    value = "gp3"
  }

  set {
    name  = "controller.nodeSelector.nodeType"
    value = "worker"
  }

  depends_on = [
    module.ebs-csi-driver-irsa
  ]
}