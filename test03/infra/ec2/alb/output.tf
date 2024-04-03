output "alb_dns_name" {
    value = aws_lb.example.dns_name
    description = "The domain name of the load balance"
}

output "target_group_jenkins_arns" {
    value = aws_lb_target_group.jenkins.arn
}

output "target_group_eks_arns" {
    value = aws_lb_target_group.project01-test03-tg.arn
}
