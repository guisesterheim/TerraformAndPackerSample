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
  associate_public_ip_address   = true // TODO: switch to false
  user_data                     = file("run_app.sh")
  key_name                      = "ssh_terraform"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "archTestLBTargetGroup" {
  name     = "ArchTestLB-TG"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.imported_vpc_id

  health_check {
      enabled = true
      path = "/healthCheck"
  }
}

resource "aws_autoscaling_group" "archTestAutoscalingGroup" {
  name                      = "ArchTestAutoscalingGroup"
  max_size                  = 1
  min_size                  = 1
  desired_capacity          = 1
  health_check_grace_period = 300
  force_delete              = true
  launch_configuration      = aws_launch_configuration.archTestConfig.name
  vpc_zone_identifier       = [var.imported_subnetEastA_id, var.imported_subnetEastB_id]
  target_group_arns         = [aws_lb_target_group.archTestLBTargetGroup.arn]

  depends_on                = [aws_lb_target_group.archTestLBTargetGroup]
}

resource "aws_lb" "archTestLB" {
  name               = "ArchTestLB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.imported_sg_external]
  subnets            = [var.imported_publicSubnetEastA_id, var.imported_publicSubnetEastB_id]
}

resource "aws_lb_listener" "archTestLBListener" {
  load_balancer_arn = aws_lb.archTestLB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.archTestLBTargetGroup.arn
  }
}

resource "aws_lb_listener_rule" "archTestListenerRuleStatic" {
  listener_arn = aws_lb_listener.archTestLBListener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.archTestLBTargetGroup.arn
  }

  condition {
    path_pattern {
      values = ["*"]
    }
  }
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