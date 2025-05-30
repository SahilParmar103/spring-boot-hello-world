terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "your-s3-backend-bucket-name"
    key            = "eks/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"
  }
}

provider "aws" {
  region = "us-east-1"
}

locals {
  cluster_name = "eks-dev-cluster"
  vpc_id       = "vpc-07d6d539f6fea04ff"
  subnet_ids   = [
    "subnet-0379237fc995b8e91", # us-east-1a
    "subnet-01edbfe6e2fe4af5a", # us-east-1b
    "subnet-0697fa3ca382ef8ca", # us-east-1c
  ]
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name    = local.cluster_name
  cluster_version = "1.29"

  vpc_id     = local.vpc_id
  subnet_ids = local.subnet_ids

  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.medium"]
      desired_size   = 2
      min_size       = 1
      max_size       = 3
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
