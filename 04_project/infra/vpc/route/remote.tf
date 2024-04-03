data "terraform_remote_state" "vpc" {
    backend = "s3"
    config = {
        bucket = "project01-terraform-state"
        key = "infra/vpc/terraform.tfstate"
        region = "ap-northeast-2"
    }
}

data "terraform_remote_state" "gateway" {
    backend = "s3"
    config = {
        bucket = "project01-terraform-state"
        key = "infra/vpc/igw/terraform.tfstate"
        region = "ap-northeast-2"
    }
}

data "terraform_remote_state" "subnet" {
    backend = "s3"
    config = {
        bucket = "project01-terraform-state"
        key = "infra/vpc/subnets/terraform.tfstate"
        region = "ap-northeast-2"
    }
}

data "terraform_remote_state" "default_route_table_id" {
    backend = "s3"
    config = {
        bucket = "project01-terraform-state"
        key = "infra/vpc/terraform.tfstate"
        region = "ap-northeast-2"
    }
}

data "terraform_remote_state" "nat" {
    backend = "s3"
    config = {
        bucket = "project01-terraform-state"
        key = "infra/vpc/EIP_NAT/terraform.tfstate"
        region = "ap-northeast-2"
    }
}