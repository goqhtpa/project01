terraform {
  backend "s3" {
    bucket = "aws04-terraform-state"
    region = "ap-northeast-2"
    key = "infra/ec2/alb/terraform.tfstate"
    dynamodb_table = "aws04-terraform-locks"
    encrypt = true
  }
}