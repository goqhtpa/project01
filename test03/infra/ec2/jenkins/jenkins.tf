resource "aws_instance" "jenkins" {
    ami           = "ami-0d3d9b94632ba1e57"
    instance_type = "t3.large"
    key_name      = "project01-key"
    private_ip = "10.103.64.100"

    subnet_id = data.terraform_remote_state.vpc.outputs.private-subnet-2a-id

    security_groups = [data.terraform_remote_state.security_group.outputs.vpc-security-group-id-ssh,
                       data.terraform_remote_state.security_group.outputs.vpc-security-group-id-http]

    user_data = templatefile("template/userdata.sh", {})
    tags   = {
      Name = "project01-test03-jenkins"
    }
}