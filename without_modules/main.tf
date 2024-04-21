provider "aws" {
  region = "us-east-1"  
}

resource "aws_iam_group" "group1" {
  name = "group1"
}

resource "aws_iam_group" "group2" {
  name = "group2"
}
  
resource "aws_iam_user" "engine" {
  name = "engine"
  path = "/"
}

resource "aws_iam_user" "ci" {
  name = "ci"
  path = "/"
}

resource "aws_iam_user" "denys" {
  name = "DenysPlaton"
  path = "/"
}

resource "aws_iam_user" "ivan" {
  name = "IvanPetrenko"
  path = "/"
}


resource "aws_iam_group_membership" "group1_membership" {
  name  = "group1-membership"
  group = aws_iam_group.group1.name
  users = [
    aws_iam_user.engine.name,
    aws_iam_user.ci.name,
  ]
}


resource "aws_iam_group_membership" "group2_membership" {
  name  = "group2-membership"
  group = aws_iam_group.group2.name
  users = [
    aws_iam_user.denys.name,
    aws_iam_user.ivan.name,
  ]
}

resource "aws_iam_group_policy" "group1_policy" {
  name  = "group1-policy"
  group = aws_iam_group.group1.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Describe*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_group_policy" "group2_policy" {
  name  = "group2-policy"
  group = aws_iam_group.group2.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "iam:*",
      "Resource": "*"
    }
  ]
}
EOF
}
resource "aws_iam_role" "roleA" {
  name = "roleA"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "policyA" {
  name = "policyA"
  role = aws_iam_role.roleA.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "*",
        Resource = "*",
        NotAction = "iam:*"
      }
    ]
  })
}

resource "aws_iam_role" "roleB" {
  name = "roleB"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "policyB" {
  name = "policyB"
  role = aws_iam_role.roleB.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Resource = "arn:aws:iam::1111111111:role/roleC"
      }
    ]
  })
}
provider "aws" {
  region = "us-east-1"  
  alias  = "account1111111111"
  assume_role {
    role_arn = "arn:aws:iam::1111111111:role/admin-role"  
  }
}


resource "aws_iam_role" "roleC" {
  provider = aws.account1111111111

  name = "roleC"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::000000000000:role/roleB"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_role_policy" "policyC" {
  provider = aws.account1111111111
  name = "policyC"
  role = aws_iam_role.roleC.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::aws-test-bucket",
          "arn:aws:s3:::aws-test-bucket/*"
        ]
      }
    ]
  })
}