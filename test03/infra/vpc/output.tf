output "vpc_id" {
    value = aws_vpc.project01-test03-vpc.id
}
output "public-subnet-2a-id" {
    value = aws_subnet.project01-test03-public-subnet-2a.id
}
output "public-subnet-2c-id" {
    value = aws_subnet.project01-test03-public-subnet-2c.id
}
output "private-subnet-2a-id" {
    value = aws_subnet.project01-test03-private-subnet-2a.id
}
output "private-subnet-2c-id" {
    value = aws_subnet.project01-test03-private-subnet-2c.id
}