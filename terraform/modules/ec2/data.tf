data "aws_ami" "packer-api" {
  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "tag:Name"
    values = ["packer-api"]
  }

  most_recent = true
}