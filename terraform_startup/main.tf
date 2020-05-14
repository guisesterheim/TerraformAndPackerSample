// Step 1: terraform init
// Step 2: terraform plan -var aws_region=us-east-1 -var aws_access_key=<access_key> -var aws_secret_key=<secret_key> -out tfout.log
// Step 3: terraform apply tfout.log

provider "aws" {
    region = var.aws_region
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

module "instances" {
    source = "./modules/instances"
}