resource "aws_security_group" "ssh" {
    vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
    name = "project01-test03-ssh"

    ingress {
        from_port = var.ssh_port
        to_port = var.ssh_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "project01-test03-ssh"
    }
}

# resource "aws_security_group" "target_http" {
#     vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
#     name = "aws04-target-http"

#     ingress {
#         from_port = var.target_port
#         to_port = var.target_port
#         protocol = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#     }

#     egress {
#         from_port = 0
#         to_port = 0
#         protocol = "-1"
#         cidr_blocks = ["0.0.0.0/0"]
#     }

#     tags = {
#       Name = "aws04-target-http"
#     }
# }

resource "aws_security_group" "http" {
    vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
    name = "project01-test03-http"

    ingress {
        from_port = var.http_port
        to_port = var.http_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "project01-test03-http"
    }
}

resource "aws_security_group" "https" {
    vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
    name = "project01-test03-https"

    ingress {
        from_port = var.https_port
        to_port = var.https_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name : "project01-test03-https"
    }
}




variable "ssh_port" {
    type = number
    default = 22
}
variable "http_port" {
    type = number
    default = 80
}
variable "https_port" {
    type = number
    default = 443
}
# variable "target_port" {
#     type = number
#     default = 8080
# }