provider "aws" {
  region = "eu-west-1"
}

module "alb" {
  source            = "modules/alb"
  environment       = "${var.environment}"
  vpc_id            = "${module.vpc.id}"
  public_subnet_ids = "${module.public_subnet.ids}"
}

module "ec2" {
  source             = "modules/ec2"
  environment        = "${var.environment}"
  vpc_id             = "${module.vpc.id}"
  private_subnet_ids = "${module.private_subnet.ids}"
  max_size           = "${var.max_size}"
  min_size           = "${var.min_size}"
  instance_type      = "${var.instance_type}"
  target_group       = "${module.alb.target_group}"
  key_name           = "${aws_key_pair.key.key_name}"
  sg_bastion         = "${module.bastion.sg_id}"
}

module "vpc" {
  source      = "modules/vpc"
  cidr        = "${var.vpc_cidr}"
  environment = "${var.environment}"
}

module "private_subnet" {
  source             = "modules/private_subnet"
  name               = "${var.environment}_private_subnet"
  environment        = "${var.environment}"
  vpc_id             = "${module.vpc.id}"
  nat_gateway_id     = "${module.nat.ids}"
  cidrs              = "${var.private_subnet_cidrs}"
  availability_zones = "${var.availability_zones}"
}

module "public_subnet" {
  source             = "modules/public_subnet"
  name               = "${var.environment}_public_subnet"
  environment        = "${var.environment}"
  vpc_id             = "${module.vpc.id}"
  igw_id             = "${module.vpc.igw}"
  cidrs              = "${var.public_subnet_cidrs}"
  availability_zones = "${var.availability_zones}"
}

module "nat" {
  source       = "modules/nat_gateway"
  vpc_id       = "${module.vpc.id}"
  subnet_ids   = "${module.public_subnet.ids}"
  subnet_count = "${length(var.public_subnet_cidrs)}"
}

module "bastion" {
  source            = "modules/bastion"
  environment       = "${var.environment}"
  vpc_id            = "${module.vpc.id}"
  public_subnet_ids = "${module.public_subnet.ids}"
  instance_type     = "${var.instance_type}"
  key_name          = "${aws_key_pair.key.key_name}"
}

resource "aws_key_pair" "awskey" {
  key_name   = "key-${var.environment}"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}

variable "vpc_cidr" {}
variable "environment" {}
variable "max_size" {}
variable "min_size" {}
variable "instance_type" {}

variable "private_subnet_cidrs" {
  type = "list"
}

variable "public_subnet_cidrs" {
  type = "list"
}

variable "availability_zones" {
  type = "list"
}
