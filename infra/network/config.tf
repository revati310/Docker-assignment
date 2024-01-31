terraform {
  backend "s3" {
    bucket = "docker-assignment1-revati"
    key    = "network/terraform.tfstate"
    region = "us-east-1"
  }
}