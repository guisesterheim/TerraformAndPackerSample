// Creates the VPC
resource "aws_vpc" "archTestVPC" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "ArchTestVPC"
  }
}

// Creates the App Subnet
resource "aws_subnet" "appSubNet" {
  vpc_id     = aws_vpc.archTestVPC.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Arch Test - App Subnet"
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

resource "aws_security_group" "arch_test_allow_app" {
  name        = "Arch Test allow App"
  description = "Allow App 8080 inbound traffic"
  vpc_id      = aws_vpc.archTestVPC.id

  ingress {
    description = "8080 from VPC"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.archTestVPC.cidr_block]
  }

  ingress {
    description = "8080 from VPC"
    from_port   = 80
    to_port     = 8080 // In the future: use proper Route 53 configuration to forward ports
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.archTestVPC.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "aws_security_group_ssh_id" {
    value = aws_security_group.arch_test_allow_ssh.id
}

output "aws_security_group_app_id" {
    value = aws_security_group.arch_test_allow_app.id
}