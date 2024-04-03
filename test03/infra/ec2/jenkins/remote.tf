data "terraform_remote_state" "vpc" {
    backend = "s3"
    config = {
        bucket = "project01-test-terraform-state"
        key = "test03/infra/vpc/terraform.tfstate"
        region = "ap-northeast-2"
    }
}

data "terraform_remote_state" "security_group" {
    backend = "s3"
    config = {
        bucket = "project01-test-terraform-state"
        key = "test03/infra/ec2/security_group/terraform.tfstate"
        region = "ap-northeast-2"
    }
}