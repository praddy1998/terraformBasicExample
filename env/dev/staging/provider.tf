provider "aws" {
    region = "ap-south-1"

    default_tags {
    tags = {
      Environment     = "Staging"
      Project         = "test"
      ManagedBy = "Terraform"
    }
  }
}

provider "aws" {
    alias = "cdn"
    region = "us-east-1"

    default_tags {
    tags = {
      Environment     = "Staging"
      Project         = "test"
      ManagedBy = "Terraform"
    }
  }
}

