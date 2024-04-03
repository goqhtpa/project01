output "vpc_id" {
    value = aws_vpc.project01-vpc.id
}

output "default_route_table_id" {
    value = aws_vpc.project01-vpc.default_route_table_id
}