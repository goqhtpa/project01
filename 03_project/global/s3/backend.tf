terraform {
  backend "s3" {
    bucket = "aws04-terraform-state"
    region = "ap-northeast-2"
    key = "global/s3/terraform.tfstate"
    dynamodb_table = "aws04-terraform-locks"
    encrypt = true
  }
}