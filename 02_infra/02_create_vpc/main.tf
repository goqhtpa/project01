resource "aws_vpc" "aws04-vpc" {
    cidr_block = var.vpc_cidr
    instance_tenancy = "default"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "aws04-vpc"
    }
}

//-------서브넷 생성-----------------------------------
// ap-northeast-2a
resource "aws_subnet" "aws04-public-subnet-2a" {
    vpc_id = aws_vpc.aws04-vpc.id
    cidr_block = var.public_subnet[0]
    availability_zone = var.azs[0]

    tags = {
        Name = "aws04-public-subnet-2a"
    }
}

resource "aws_subnet" "aws04-private-subnet-2a" {
    vpc_id = aws_vpc.aws04-vpc.id
    cidr_block = var.private_subnet[0]
    availability_zone = var.azs[0]

    tags = {
        Name = "aws04-private-subnet-2a"
    }
}

// ap-northeast-2c
resource "aws_subnet" "aws04-public-subnet-2c" {
    vpc_id = aws_vpc.aws04-vpc.id
    cidr_block = var.public_subnet[1]
    availability_zone = var.azs[1]

    tags = {
        Name = "aws04-public-subnet-2c"
    }
}

resource "aws_subnet" "aws04-private-subnet-2c" {
    vpc_id = aws_vpc.aws04-vpc.id
    cidr_block = var.private_subnet[1]
    availability_zone = var.azs[1]

    tags = {
        Name = "aws04-private-subnet-2c"
    }
}

//게이트웨이
resource "aws_internet_gateway" "aws04-igw" {
    vpc_id = aws_vpc.aws04-vpc.id

    tags = {
        Name = "aws04-igw"
    }
}

//EIP
resource "aws_eip" "aws04-eip" {
    domain = "vpc"
    depends_on = [aws_internet_gateway.aws04-igw]
    lifecycle {
        create_before_destroy = true
    }

    tags = {
        Name = "aws04-eip"
    }
}

//NAT게이트웨이
resource "aws_nat_gateway" "aws04-nat" {
    allocation_id = aws_eip.aws04-eip.id
    subnet_id = aws_subnet.aws04-public-subnet-2a.id
    depends_on = [ aws_internet_gateway.aws04-igw ]

    tags = {
        Name = "aws04-nat"
    }
}

//라우터
resource "aws_default_route_table" "aws04-public-rt-table" {
    default_route_table_id = aws_vpc.aws04-vpc.default_route_table_id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.aws04-igw.id
    }

    tags = {
        Name = "aws04-public-rt-table"
    }
}

resource "aws_route_table_association" "aws04-public-rt-2a" {
    subnet_id = aws_subnet.aws04-public-subnet-2a.id
    route_table_id = aws_default_route_table.aws04-public-rt-table.id
}

resource "aws_route_table_association" "aws04-public-rt-2c" {
    subnet_id = aws_subnet.aws04-public-subnet-2c.id
    route_table_id = aws_default_route_table.aws04-public-rt-table.id
}

# private route table
resource "aws_route_table" "aws04-private-rt-table" {
    vpc_id = aws_vpc.aws04-vpc.id
    tags = {
        Name = "aws04-private-rt-table"
    }
}
# private route
resource "aws_route" "aws04-private-rt-table" {
    route_table_id = aws_route_table.aws04-private-rt-table.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.aws04-nat.id
}

resource "aws_route_table_association" "aws04-private-rt-2a" {
    subnet_id = aws_subnet.aws04-private-subnet-2a.id
    route_table_id = aws_route_table.aws04-private-rt-table.id
}

resource "aws_route_table_association" "aws04-private-rt-2c" {
    subnet_id = aws_subnet.aws04-private-subnet-2c.id
    route_table_id = aws_route_table.aws04-private-rt-table.id
}