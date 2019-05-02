vpc_cidr = "10.172.0.0/16"

environment = "staging/production"

public_subnet_cidrs = ["10.172.1.0/24", "10.172.2.0/24"]

private_subnet_cidrs = ["10.172.81.0/24", "10.172.82.0/24"]

availability_zones = ["eu-west-1a", "eu-west-1b"]

max_size = 4

min_size = 2

instance_type = "t2.micro"

variable "PATH_TO_PUBLIC_KEY" {
  default = "awskey.pub"
}
variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}