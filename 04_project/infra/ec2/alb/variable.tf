variable "http-port" {
  description = "The port will use for HTTP 80 requests"
  type        = number
  default     = 80
}

variable "jenkins-port" {
  description = "The port will use for jenkins 8080 requests"
  type        = number
  default     = 8080
}


variable "https-port" {
  description = "The port will use for HTTPS 443 requests"
  type        = number
  default     = 443
}

# variable "alb-arn" {
#   description = "alb-arn"
#   type = string
#   default = "arn:aws:elasticloadbalancing:ap-northeast-2:257307634175:loadbalancer/app/k8s-default-ingresst-b51a4a328a/d4aa8eb2bf525c39"
# }

# variable "alb-dns-name" {
#   description = "alb-dns-name"
#   type = string
#   default = "k8s-default-ingresst-b51a4a328a-590831537.ap-northeast-2.elb.amazonaws.com"
# }