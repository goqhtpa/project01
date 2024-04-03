resource "aws_instance" "target" {
    ami           = "ami-09eb4311cbaecf89d"
    instance_type = "t2.micro"
    key_name      = "aws04-key"

    subnet_id = data.terraform_remote_state.vpc.outputs.public-subnet-2a-id

    user_data = templatefile("template/userdata.sh", {})

    associate_public_ip_address = true

    security_groups = [data.terraform_remote_state.security_group.outputs.vpc-security-group-id-ssh]
    tags   = {
      Name = "aws04-target"
    }
}