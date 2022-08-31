data "aws_eks_cluster" "this" {
  name = local.config.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = local.config.cluster_name
}
