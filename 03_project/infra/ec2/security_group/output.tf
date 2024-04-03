output "vpc-security-group-id-ssh" {
   value = aws_security_group.ssh.id
}

output "vpc-security-group-id-http" {
   value = aws_security_group.http.id
}

output "vpc-security-group-id-https" {
   value = aws_security_group.https.id
}

output "target_http_id" {
   value = aws_security_group.target_http.id
}