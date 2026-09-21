terraform {
  backend "s3" {
    bucket       = "rutvik-s3-tfstate"
    region       = "ap-south-1"
    key          = "Tetrics-devops-project/Jenkins-Server-TF/terraform.tfstate"
    encrypt      = true
    use_lockfile = true
  }
  required_version = ">=1.13.3"
  required_providers {
    aws = {
      version = ">= 6.23.0"
      source  = "hashicorp/aws"
    }
  }
}
