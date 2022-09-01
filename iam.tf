################################################################################
# user groups - mlops_admin (not authrized on poc env)
################################################################################

#resource "aws_iam_group" "mlops_admin" {
#  name = "tf-mlops-admin"  
#}

# Define policy ARNs as list
variable "mlops_group_policy_arn" {
  description = "IAM Policy to be attached to mlops group"
  type = list(string)
}

#resource "aws_iam_group_policy_attachment" "mlops_group_policy_attachment" {
#  group      = aws_iam_group.mlops_admin.name
#  count = length(var.mlops_group_policy_arn)
#  policy_arn = element(var.mlops_group_policy_arn, count.index) 
#}

################################################################################
# Step Function role
################################################################################

resource "aws_iam_role" "stepfunction" {
  name               = "tf-mlops-stepfunction-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "states.ap-northeast-2.amazonaws.com"
        }
      },
    ]
  })

}

# Define policy ARNs as list
variable "mlops_stepfunction_role_policy_arn" {
  description = "IAM Policy to be attached to stepfunction role"
  type = list(string)
}

resource "aws_iam_role_policy_attachment" "stepfunction_role_policy_attachment" {
  role   = aws_iam_role.stepfunction.name
  count = length(var.mlops_stepfunction_role_policy_arn)
  policy_arn = element(var.mlops_stepfunction_role_policy_arn, count.index)
}

################################################################################
# Lambda role
################################################################################

resource "aws_iam_role" "lambda" {
  name = "tf-mlops-lambda-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

}

# Define policy ARNs as list
variable "mlops_lambda_role_policy_arn" {
  description = "IAM Policy to be attached to lambda role"
  type = list(string)
}

resource "aws_iam_role_policy_attachment" "lambda_role_policy_attachment" {
  role   = aws_iam_role.lambda.name
  count = length(var.mlops_lambda_role_policy_arn)
  policy_arn = element(var.mlops_lambda_role_policy_arn, count.index)
}
