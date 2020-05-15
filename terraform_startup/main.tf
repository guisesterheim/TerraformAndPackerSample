// Step 1: terraform init
// Step 2: terraform plan -var aws_region1=us-east-1 -var aws_region2=sa-east-1 -var aws_access_key=<access_key> -var aws_secret_key=<secret_key> -out tfout.log
// Step 3: terraform apply tfout.log

provider "aws" {
    regions = [var.aws_region1, var.aws_region2]
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
}

variable "aws_region" {
    description = "AWS Region to launch the infrastructure"
}

variable "aws_access_key" {
    description = "AWS Access Key"
}

variable "aws_secret_key" {
    description = "AWS Secret KEy"
}

module "network" {
    source = "./modules/network"
}

module "autoscaling" {
imported_sg_ssh                 = module.network.aws_security_group_ssh_id
    imported_sg_app             = module.network.aws_security_group_app_id
    imported_subneteast_id      = module.network.aws_subnet_east_id
    imported_subnetsouth_id     = module.network.aws_subnet_south_id

    source                      = "./modules/autoscaling"
}