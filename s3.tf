resource "aws_s3_bucket" "offline_features" {
  bucket = "tf-offline-features"
  acl    = "private"

  lifecycle_rule {
    id      = "log"
    enabled = true

    prefix = "log/"

    tags = {
      rule      = "log"
      autoclean = "true"
    }

    transition {
      days          = 1
      storage_class = "GLACIER"
    }

    expiration {
      days = 2
    }
  }
}

resource "aws_s3_bucket" "step_function_code" {
  bucket = "tf-step-function-code"
}

resource "aws_s3_bucket" "model_artifacts" {
  bucket = "tf-model-artifacts"
}



