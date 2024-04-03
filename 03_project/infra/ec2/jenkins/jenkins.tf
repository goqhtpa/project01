resource "aws_instance" "jenkins" {
    ami           = "ami-09eb4311cbaecf89d"
    instance_type = "t3.large"
    key_name      = "aws04-key"
    private_ip = "10.4.64.100"

    subnet_id = data.terraform_remote_state.vpc.outputs.private-subnet-2a-id

    security_groups = [data.terraform_remote_state.security_group.outputs.vpc-security-group-id-ssh,
                       data.terraform_remote_state.security_group.outputs.vpc-security-group-id-http]

    user_data = templatefile("template/userdata.sh", {})
    tags   = {
      Name = "aws04-jenkins"
    }
}