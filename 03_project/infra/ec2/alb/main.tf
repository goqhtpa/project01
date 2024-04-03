//로드밸런스
resource "aws_lb" "example" {
  name               = "aws04-alb"
  load_balancer_type = "application"
  subnets            = [data.terraform_remote_state.vpc.outputs.public-subnet-2a-id,
                        data.terraform_remote_state.vpc.outputs.public-subnet-2c-id]
  security_groups    = [data.terraform_remote_state.security_group.outputs.vpc-security-group-id-http]
}

// 로드밸런스 리스너 - jenkins
resource "aws_lb_listener" "jenkins_http" {
  load_balancer_arn = aws_lb.example.arn
  port              = 80
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
  listener_arn = aws_lb_listener.jenkins_http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins.arn
  }

  condition {
    host_header {
      values = ["aws04-jenkins.busanit-lab.com"]
    }
  }
}

//대상그룹 - Jenkins EC2
resource "aws_lb_target_group" "jenkins" {
  name     = "aws04-jenkins"
  target_type = "instance"
  port     = var.http_port
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
  port = var.http_port
}

// 시작 템플릿
resource "aws_launch_template" "example" {
  name                   = "aws04-template"
  image_id               = "ami-0ce48062351f8d8a0"
  instance_type          = "t2.micro"
  key_name               = "aws04-key"
  vpc_security_group_ids = [data.terraform_remote_state.security_group.outputs.vpc-security-group-id-http]
  iam_instance_profile {
    name = "aws04-codedeploy-ec2-role"
  }

  lifecycle {
    create_before_destroy = true
  }
}

// 오토스케일링 그룹
resource "aws_autoscaling_group" "example" {
  vpc_zone_identifier = [data.terraform_remote_state.vpc.outputs.private-subnet-2a-id,
                         data.terraform_remote_state.vpc.outputs.private-subnet-2c-id]
  name               = "aws04-asg"
  desired_capacity   = 1
  min_size           = 1
  max_size           = 3

  target_group_arns = [aws_lb_target_group.aws04-tg.arn]
  // health_check_type = "ELB"

  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "aws04-spring-petclinic"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_target" {
  autoscaling_group_name = aws_autoscaling_group.example.id
  lb_target_group_arn = aws_lb_target_group.aws04-tg.arn
}

// 로드밸런스 리스너 - asg
resource "aws_lb_listener" "target_http" {
  load_balancer_arn = aws_lb.example.arn
  port              = var.http_port
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

//로드밸런스 리스너 룰 - target group
resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.target_http.arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.aws04-tg.arn
  }

  condition {
    host_header {
      values = ["aws04-target.busanit-lab.com"]
    }
  }
}

//대상그룹
resource "aws_lb_target_group" "aws04-tg" {
  name     = "aws04-target-group"
  port     = var.http_port
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