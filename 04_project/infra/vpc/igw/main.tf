//게이트웨이
resource "aws_internet_gateway" "project01-igw" {
    vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

    tags = {
        Name = "project01-igw"
    }
}