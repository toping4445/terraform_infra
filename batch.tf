resource "aws_batch_compute_environment" "fargate" {
  compute_environment_name = "tf-fargate-ce"

  compute_resources {
    max_vcpus = 256

    security_group_ids = [
      aws_security_group.mlops_default.id
    ]

    subnets = [
      aws_subnet.private.id
    ]

    type = "FARGATE"
  }

  service_role = aws_iam_role.batch_ce.arn
  type         = "MANAGED"
  depends_on   = [aws_iam_role_policy_attachment.batch_ce]
}


resource "aws_batch_compute_environment" "fargate_spot" {
  compute_environment_name = "tf-fargate-spot-ce"

  compute_resources {
    max_vcpus = 256

    security_group_ids = [
      aws_security_group.mlops_default.id
    ]

    subnets = [
      aws_subnet.private.id
    ]

    type = "FARGATE_SPOT"
  }

  service_role = aws_iam_role.batch_ce.arn
  type         = "MANAGED"
  depends_on   = [aws_iam_role_policy_attachment.batch_ce]
}

resource "aws_batch_job_queue" "fargate_jq" {
  name     = "tf-fargate-jq"
  state    = "ENABLED"
  priority = 1
  compute_environments = [
    aws_batch_compute_environment.fargate.arn,
  ]
}

resource "aws_batch_job_queue" "fargate_spot_jq" {
  name     = "tf-fargate-spot-jq"
  state    = "ENABLED"
  priority = 1
  compute_environments = [
    aws_batch_compute_environment.fargate_spot.arn,
  ]
}