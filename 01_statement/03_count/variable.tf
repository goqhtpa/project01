variable "user_names" {
    description = "Create IAM users with these names"
    type        = list(string)
    default     = ["aws04-neo", "aws04-trinity", "aws04-morpheus"]
}