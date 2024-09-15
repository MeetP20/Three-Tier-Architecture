resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.Web-Server.id
}

resource "aws_eip" "nat" {
   domain = "vpc"
} 

resource "aws_nat_gateway" "NAT" {
    allocation_id = aws_eip.nat.id
    subnet_id = aws_subnet.Public_Subnet.id
}

resource "aws_route_table" "Public_Route" {
    vpc_id = aws_vpc.Web-Server.id
    route {
        cidr_block = "10.0.0.0/25"
        gateway_id = "local"
    }
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.example.id
    }
}

resource "aws_route_table" "Private_Route" {
    vpc_id = aws_vpc.Web-Server.id
    route {
        cidr_block = "10.0.0.128/25"
        gateway_id = "local"
    }
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.NAT.id
    }
}

resource "aws_route_table_association" "Public" {
    subnet_id = aws_subnet.Public_Subnet.id
    route_table_id = aws_route_table.Public_Route.id
}

resource "aws_route_table_association" "Private" {
    subnet_id = aws_subnet.Private_Subnet.id
    route_table_id = aws_route_table.Private_Route.id
}