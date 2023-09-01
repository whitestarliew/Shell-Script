resource "aws_iam_policy" "user_pool_policy" {
  name = "UserPoolPolicy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "cognito-idp:CreateUserPool",
          "cognito-idp:CreateUserPoolClient"
        ],
        Resource = "*",
        Condition = {
          StringEqualsIfExists = {
            "aws:RequestedRegion" : "eu-west-2"
          }
        }
      },
      {
        Effect   = "Allow",
        Action   = [
          "cognito-idp:AdminCreateUser"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "michael_role" {
  name = "MichaelRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          AWS = "arn:aws:iam::YOUR_ACCOUNT_ID:user/michael"  # Replace with michael's user ARN
        },
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "user_pool_attachment" {
  policy_arn = aws_iam_policy.user_pool_policy.arn
  role       = aws_iam_role.michael_role.name
}
=======================================================================

Lambda 

resource "aws_iam_role" "lambda_execution_role" {
  name = "LambdaExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name = "LambdaPolicy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "cognito-idp:AdminCreateUser",
          "cognito-idp:AdminGetUser"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_policy.arn
  role       = aws_iam_role.lambda_execution_role.name
}
