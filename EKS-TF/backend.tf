terraform {
  backend "s3" {
    bucket       = "EKS-tf-bucket"
    region       = "ap-south-1"
    key          = "Tetrics-project/EKS-TF/terraform.tfstate"
    use_lockfile = true
    encrypt      = true
  }
  required_version = ">=1.14.0"
  required_providers {
    aws = {
      version = ">= 5.49.0"
      source  = "hashicorp/aws"
    }
  }
}
