terraform {
  backend "s3" {
    bucket = "daily-file-ars"
    key    = "terraform.tfstate"
    region = "sa-east-1"
  }
}