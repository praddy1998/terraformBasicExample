terraform {
  backend "s3" {
    bucket = "test-terraform-remote-backend"
    key    = "backend/stage/terraform.tfstate"
    region = "ap-south-1"
  }
}