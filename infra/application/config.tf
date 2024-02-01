terraform {
  backend "s3" {
    bucket = "docker-assignment1-revati"
    key    = "webserver/terraform.tfstate"
    region = "us-east-1"
  }
}