
variable "aws_region" {
    description = "AWS Region"
}

variable "aws_access_key" {
    description = "AWS Access Key"
}

variable "aws_secret_key" {
    description = "AWS Secret KEy"
}

variable "availability_zone_us_east_1" {
    description = "Availability zone 1"
    default = "us-east-1a"
}

variable "availability_zone_us_east_2" {
    description = "Availability zone 2"
    default = "us-east-1b"
}