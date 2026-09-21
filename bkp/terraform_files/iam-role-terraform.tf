resource "aws_iam_role" "terraform_execution_role" {
  name = "TerraformExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"

        Principal = {
          AWS = "arn:aws:iam::181188392770:user/cli-admin"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}
