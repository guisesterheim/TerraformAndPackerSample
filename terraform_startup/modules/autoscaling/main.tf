// Check which is the most recent AMI image to use
data "aws_ami" "image" {
  most_recent = true
  owners = ["self"]
  filter {
    name = "tag:Name"
    values = ["archTestIlegraAMI"]
  }
}

resource "aws_launch_configuration" "archTestConfig" {
  name                          = "ArchTestEC2LC"
  image_id                      = data.aws_ami.image.id
  instance_type                 = "t2.micro"
  security_groups               = [var.imported_sg_ssh, var.imported_sg_app]
  associate_public_ip_address   = false
  user_data                     = file("run_app.sh")
  key_name                      = "ssh_terraform"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "archTestAutoscalingGroup" {
  availability_zones = [var.imported_az1, var.imported_az2]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1
  launch_configuration = aws_launch_configuration.archTestConfig.name
  vpc_zone_identifier  = [var.imported_subneteast_id, var.imported_subnetsouth_id]
}

// Creates the instances
/*
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
*/