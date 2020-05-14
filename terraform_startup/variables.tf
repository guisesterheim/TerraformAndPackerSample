variable "allow_app_sg" {
    description = "Security group to allow ingress to the app instances"
    type = string
}

variable "allow_ssh_sg" {
    description = "Security group to allow SSH ingress to the app instances"
    type = string
}