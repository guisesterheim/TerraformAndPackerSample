// Creates the VPC
resource "aws_vpc" "archTestVPC" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "ArchTestVPC"
  }
}

resource "aws_internet_gateway" "archTestInternetGateway" {
  vpc_id = aws_vpc.archTestVPC.id

  tags = {
    Name = "ArchTestInternetGateway"
  }
}

// Creates the App Subnet
resource "aws_subnet" "appSubNetEastA" {
  vpc_id            = aws_vpc.archTestVPC.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.imported_az1

  tags = {
    Name = "Arch Test - App Subnet A"
  }
}

// Creates the App Subnet
resource "aws_subnet" "appSubNetEastB" {
  vpc_id            = aws_vpc.archTestVPC.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.imported_az2

  tags = {
    Name = "Arch Test - App Subnet B"
  }
}

resource "aws_eip" "archTestNATIPEastA" {
  vpc      = true
  
  tags = {
    Name = "Arch Test - Elastic IP Subnet A"
  }
}

resource "aws_eip" "archTestNATIPEastB" {
  vpc      = true

  tags = {
    Name = "Arch Test - Elastic IP Subnet B"
  }
}

resource "aws_nat_gateway" "archTestNATEastA" {
  allocation_id = aws_eip.archTestNATIPEastA.id
  subnet_id     = aws_subnet.appSubNetEastA.id

  tags = {
    Name = "NAT Gateway East A"
  }
}

resource "aws_nat_gateway" "archTestNATEastB" {
  allocation_id = aws_eip.archTestNATIPEastB.id
  subnet_id     = aws_subnet.appSubNetEastB.id

  tags = {
    Name = "NAT Gateway East B"
  }
}

// Creates the security groups
resource "aws_security_group" "arch_test_allow_ssh" {
  name        = "Arch Test Allow SSH"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.archTestVPC.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpc.archTestVPC.cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "arch_test_external_app" {
  name        = "Arch Test Allow External App"
  description = "Allow App 8080 inbound traffic"
  vpc_id      = aws_vpc.archTestVPC.id

  ingress {
    description = "Inbound external"
    from_port   = 80
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Inbound external"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "arch_test_allow_app" {
  name        = "Arch Test allow App"
  description = "Allow App 8080 inbound traffic"
  vpc_id      = aws_vpc.archTestVPC.id

  ingress {
    description = "8080 from VPC"
    from_port   = 8080
    to_port     = 8080
    security_groups = [aws_security_group.arch_test_external_app.id]
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.archTestVPC.cidr_block]
  }

  ingress {
    description = "8080 from VPC"
    from_port   = 80
    to_port     = 80
    security_groups = [aws_security_group.arch_test_external_app.id]
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.archTestVPC.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on    = [aws_security_group.arch_test_external_app]
}

resource "aws_route_table" "archTestRoute" {
  vpc_id = aws_vpc.archTestVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.archTestInternetGateway.id
  }

  tags = {
    Name = "Route Gateway"
  }
}

output "aws_security_group_ssh_id" {
    value = aws_security_group.arch_test_allow_ssh.id
}

output "aws_security_group_app_id" {
    value = aws_security_group.arch_test_allow_app.id
}

output "aws_security_group_allow_external" {
    value = aws_security_group.arch_test_external_app.id
}

output "aws_subnet_eastA_id" {
    value = aws_subnet.appSubNetEastA.id
}
output "aws_subnet_eastB_id" {
    value = aws_subnet.appSubNetEastB.id
}

output "aws_created_vpc_id" {
    value = aws_vpc.archTestVPC.id
}