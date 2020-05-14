// Check which is the most recent AMI image to use
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
    vpc_security_group_ids=[var.allow_app_sg, var.allow_ssh_sg]
    key_name = "ssh_terraform"
    subnet_id = aws_subnet.appSubNet.id
    associate_public_ip_address = true

    tags = {
        Name = "MicroserviceArchTest"
    }
}