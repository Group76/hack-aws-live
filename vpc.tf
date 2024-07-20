#VPC Setting
resource "aws_vpc" "default" {
  cidr_block = "10.16.0.0/16"
}
