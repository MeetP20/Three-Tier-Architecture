resource "aws_vpc" "Web-Server" {
    cidr_block = "10.0.0.0/24"
    enable_dns_support = true
    enable_dns_hostnames = true
}

resource "aws_subnet" "Public_Subnet"{
    vpc_id = aws_vpc.Web-Server.id
    cidr_block = "10.0.0.0/25"
    availability_zone = "us-east-1a"
}

resource "aws_subnet" "Private_Subnet"{
    vpc_id = aws_vpc.Web-Server.id
    cidr_block = "10.0.0.128/25"
    availability_zone = "us-east-1a"
}


