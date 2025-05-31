terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "bucketforazur"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}

provider "aws" {
  region = "us-east-1"
}


# ✅ ECR Repository for Spring Boot App
resource "aws_ecr_repository" "spring_boot_app" {
  name                 = "spring-boot-app"
  image_tag_mutability = "MUTABLE"

  tags = {
    Name        = "spring-boot-app"
    Environment = "dev"
    Terraform   = "true"
  }
}



module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name    = "eks-dev-cluster"
  cluster_version = "1.31"

  # Optional
  cluster_endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  cluster_compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  vpc_id     = "vpc-07d6d539f6fea04ff"
  subnet_ids = ["subnet-0379237fc995b8e91", "subnet-01edbfe6e2fe4af5a", "subnet-0697fa3ca382ef8ca"]

  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.medium"]
      desired_size   = 2
      min_size       = 1
      max_size       = 3
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
