module "app-mesh-irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.0.0"

  role_name = "app-mesh"

  role_policy_arns = {
    app-mesh = aws_iam_policy.app-mesh.arn
  }

  oidc_providers = {
    ex = {
      provider_arn               = local.config.oidc_arn
      namespace_service_accounts = ["appmesh-system:appmesh-controller"]
    }
  }
}

resource "aws_iam_policy" "app-mesh" {
  name   = "app-mesh"
  policy = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
		"appmesh:ListVirtualRouters",
		"appmesh:ListVirtualServices",
		"appmesh:ListRoutes",
		"appmesh:ListGatewayRoutes",
		"appmesh:ListMeshes",
		"appmesh:ListVirtualNodes",
		"appmesh:ListVirtualGateways",
		"appmesh:DescribeMesh",
		"appmesh:DescribeVirtualRouter",
		"appmesh:DescribeRoute",
		"appmesh:DescribeVirtualNode",
		"appmesh:DescribeVirtualGateway",
		"appmesh:DescribeGatewayRoute",
		"appmesh:DescribeVirtualService",
		"appmesh:CreateMesh",
		"appmesh:CreateVirtualRouter",
		"appmesh:CreateVirtualGateway",
		"appmesh:CreateVirtualService",
		"appmesh:CreateGatewayRoute",
		"appmesh:CreateRoute",
		"appmesh:CreateVirtualNode",
		"appmesh:UpdateMesh",
		"appmesh:UpdateRoute",
		"appmesh:UpdateVirtualGateway",
		"appmesh:UpdateVirtualRouter",
		"appmesh:UpdateGatewayRoute",
		"appmesh:UpdateVirtualService",
		"appmesh:UpdateVirtualNode",
		"appmesh:DeleteMesh",
		"appmesh:DeleteRoute",
		"appmesh:DeleteVirtualRouter",
		"appmesh:DeleteGatewayRoute",
		"appmesh:DeleteVirtualService",
		"appmesh:DeleteVirtualNode",
		"appmesh:DeleteVirtualGateway"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:CreateServiceLinkedRole"
            ],
            "Resource": "arn:aws:iam::*:role/aws-service-role/appmesh.amazonaws.com/AWSServiceRoleForAppMesh",
            "Condition": {
                "StringLike": {
                    "iam:AWSServiceName": [
                        "appmesh.amazonaws.com"
                    ]
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "acm:ListCertificates",
                "acm:DescribeCertificate",
                "acm-pca:DescribeCertificateAuthority",
                "acm-pca:ListCertificateAuthorities"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
		"servicediscovery:CreateService",
		"servicediscovery:DeleteService",
		"servicediscovery:GetService",
		"servicediscovery:GetInstance",
		"servicediscovery:RegisterInstance",
		"servicediscovery:DeregisterInstance",
		"servicediscovery:ListInstances",
		"servicediscovery:ListNamespaces",
		"servicediscovery:ListServices",
		"servicediscovery:GetInstancesHealthStatus",
		"servicediscovery:UpdateInstanceCustomHealthStatus",
		"servicediscovery:GetOperation",
		"route53:GetHealthCheck",
		"route53:CreateHealthCheck",
		"route53:UpdateHealthCheck",
		"route53:ChangeResourceRecordSets",
		"route53:DeleteHealthCheck"
            ],
            "Resource": "*"
        }
    ]
}
  EOF
}


resource "helm_release" "app-mesh" {
  namespace        = "appmesh-system"
  create_namespace = true

  name       = "app-mesh"
  repository = "https://aws.github.io/eks-charts"
  chart      = "appmesh-controller"
  version    = "1.6.0"

  set {
    name  = "nodeSelector.nodeType"
    value = "worker"
  }

  set {
    name  = "serviceAccount.name"
    value = "appmesh-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "arn:aws:iam::688339442457:role/app-mesh"
  }

  set {
    name  = "region"
    value = "ap-northeast-2"
  }

  set {
    name  = "accountId"
    value = "688339442457"
  }

  set {
    name  = "clusterName"
    value = local.config.cluster_name
  }

  set {
    name  = "tracing.enabled"
    value = "true"
  }

  depends_on = [
    module.app-mesh-irsa
  ]
}
