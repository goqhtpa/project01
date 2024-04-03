//로드밸런스
resource "aws_lb" "project01-alb" {
  name               = "project01-alb"
  load_balancer_type = "application"
  subnets            = [data.terraform_remote_state.subnet.outputs.public-subnet-2a-id,
                        data.terraform_remote_state.subnet.outputs.public-subnet-2c-id]
  security_groups    = [data.terraform_remote_state.Security_groups.outputs.http_id,
                        data.terraform_remote_state.Security_groups.outputs.https_id]
}

// 로드밸런스 리스너 - http
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.project01-alb.arn
  port              = var.http-port
  protocol          = "HTTP"
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

//로드밸런스 리스너 룰 - jenkins
resource "aws_lb_listener_rule" "jenkins" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins.arn
  }

  condition {
    host_header {
      values = ["project01-jenkins.busanit-lab.com"]
    }
    # path_pattern {
    #   values = ["*"]
    # }
  }
}

//대상그룹 - Jenkins EC2
resource "aws_lb_target_group" "jenkins" {
  name     = "project01-jenkins"
  target_type = "instance"
  port     = var.jenkins-port
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.vpc.outputs.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "jenkins" {
  target_group_arn = aws_lb_target_group.jenkins.arn
  target_id = data.terraform_remote_state.jenkins_instance.outputs.jenkins_id
  port = var.jenkins-port
}


# // 로드밸런스 리스너 - eks
# resource "aws_lb_listener" "eks_https" {
#   load_balancer_arn = aws_lb.project01-alb.arn
#   port              = var.http-port
#   protocol          = "HTTP"
#   certificate_arn = aws_lb.project01-alb.arn
#   default_action {
#     type = "fixed-response"

#     fixed_response {
#       content_type = "text/plain"
#       message_body = "404: page not found"
#       status_code  = 404
#     }
#   }
# }

//로드밸런스 리스너 룰 - eks
resource "aws_lb_listener_rule" "eks" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.eks.arn
  }

  condition {
    host_header {
      values = ["project01-eks.busanit-lab.com"]
    }
  }
}

//대상그룹
resource "aws_lb_target_group" "eks" {
  name     = "project01-eks"
  port     = var.http-port
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.vpc.outputs.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

//대상그룹 - 그라파나
resource "aws_lb_target_group" "grafana" {
  name     = "project01-grafana"
  target_type = "instance"
  port     = var.http-port
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.vpc.outputs.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

//로드밸런스 리스너 룰 - grafana
resource "aws_lb_listener_rule" "grafana" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 98

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grafana.arn
  }

  condition {
    host_header {
      values = ["project01-grafana.busanit-lab.com"]
    }
    # path_pattern {
    #   values = ["*"]
    # }
  }
}