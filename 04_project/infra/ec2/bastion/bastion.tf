resource "aws_instance" "bastion" {
    ami           = "ami-02c956980e9e063e5"
    instance_type = "t2.micro"
    key_name      = "project01-key"

    subnet_id = data.terraform_remote_state.subnet.outputs.public-subnet-2a-id

    associate_public_ip_address = true

    security_groups = [data.terraform_remote_state.security_group.outputs.ssh_id]
    tags   = {
      Name = "project01-bastion"
    }
}