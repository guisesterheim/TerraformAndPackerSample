// Check which is the most recent AMI image to use
variable "imported_subnet_id" {
    type = string
}

variable "imported_sg_ssh" {
    type = string
}

variable "imported_sg_app" {
    type = string
}

data "aws_ami" "image" {
  most_recent = true
  owners = ["self"]
  filter {
    name = "tag:Name"
    values = ["archTestIlegraAMI"]
  }
}

// Creates the instances
resource "aws_instance" "app" {
    count = 1
    ami = data.aws_ami.image.id
    instance_type = "t2.micro"
    user_data = file("run_app.sh")
    vpc_security_group_ids=[var.imported_sg_ssh, var.imported_sg_app]
    key_name = "ssh_terraform"
    subnet_id = var.imported_subnet_id
    associate_public_ip_address = true

    tags = {
        Name = "MicroserviceArchTest"
    }
}