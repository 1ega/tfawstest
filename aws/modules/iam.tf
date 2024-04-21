provider "aws" {
  region = "us-east-1"  
}

resource "aws_iam_user" "user" {
  for_each = toset(["engine", "ci", "Denys Platon", "Ivan Petrenko"])

  name = each.value
}


resource "aws_iam_group" "cli_group" {
  name = "CLI_Access_Group"
}

resource "aws_iam_group_policy" "cli_policy" {
  group = aws_iam_group.cli_group.id

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["ec2:Describe*", "s3:ListBucket"],
      Resource = "*"
    }]
  })
}

resource "aws_iam_group" "full_access_group" {
  name = "Full_Access_Group"
}

resource "aws_iam_group_policy" "full_access_policy" {
  group = aws_iam_group.full_access_group.id

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = "*",
      Resource = "*"
    }]
  })
}

resource "aws_iam_user_group_membership" "group_membership" {
  for_each = {
    "engine"       = "CLI_Access_Group",
    "ci"           = "CLI_Access_Group",
    "Denys Platon" = "Full_Access_Group",
    "Ivan Petrenko" = "Full_Access_Group"
  }

  user   = each.key
  groups = [aws_iam_group[each.value].name]
}

resource "aws_iam_role" "roleA" {
  name = "roleA"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "roleA_policy" {
  role = aws_iam_role.roleA.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = "*",
      Resource = "*",
      NotAction = "iam:*"
    }]
  })
}

resource "aws_iam_role" "roleB" {
  name = "roleB"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole",
      Condition = {
        StringEquals = {
          "sts:ExternalId": "12345"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy" "roleB_policy" {
  role = aws_iam_role.roleB.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = "sts:AssumeRole",
      Resource = "arn:aws:iam::1111111111:role/roleC"
    }]
  })
}

resource "aws_iam_role" "roleC" {
  provider = aws.account1111111111
  name     = "roleC"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        AWS = "arn:aws:iam::000000000000:role/roleB"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "roleC_policy" {
provider = aws.account1111111111
  role     = aws_iam_role.roleC.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["s3:GetObject", "s3:ListBucket"],
      Resource = ["arn:aws:s3:::aws-test-bucket", "arn:aws:s3:::aws-test-bucket/*"]
    }]
  })
}
