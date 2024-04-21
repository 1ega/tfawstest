terraform {
  required_version = "~> 1.0"
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

module "iam_users_and_groups" {
  source = "../modules/"

  user_names     = ["engine", "ci", "Denys Platon", "Ivan Petrenko"]
  groups = {
    "CLI_Access"   = ["engine", "ci"],
    "Full_Access"  = ["Denys Platon", "Ivan Petrenko"]
  }
  group_policies = {
    "CLI_Access"   = jsonencode({
      Version   = "2012-10-17",
      Statement = [{
        Effect   = "Allow",
        Action   = ["ec2:Describe*", "s3:ListBucket"],
        Resource = "*"
      }]
    }),
    "Full_Access"  = jsonencode({
      Version   = "2012-10-17",
      Statement = [{
        Effect   = "Allow",
        Action   = "*",
        Resource = "*"
      }]
    })
  }
  enable_roleA = true
  enable_roleB = true
  enable_roleC = true

  roleA_name = "roleA"
  roleB_name = "roleB"
  roleC_name = "roleC"
  roleC_account_id = "1111111111"

  roleA_policy_document = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = "*",
      Resource = "*",
      NotAction = "iam:*"
    }]
  })

  roleB_policy_document = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = "sts:AssumeRole",
      Resource = "arn:aws:iam::1111111111:role/roleC"
    }]
  })

  roleC_policy_document = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["s3:GetObject", "s3:ListBucket"],
      Resource = ["arn:aws:s3:::${var.s3_bucket_name}", "arn:aws:s3:::${var.s3_bucket_name}/*"]
    }]
  })
}


  
