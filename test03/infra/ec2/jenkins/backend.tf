terraform {
  backend "s3" {
    bucket = "project01-test-terraform-state"
    region = "ap-northeast-2"
    key = "test03/infra/ec2/jenkins/terraform.tfstate"
    dynamodb_table = "project01-test03-terraform-locks"
    encrypt = true
  }
}