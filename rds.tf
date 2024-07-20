provider "random" {}

resource "aws_db_instance" "portal_rds" {
  allocated_storage    = 10
  db_name              = "order"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "order"
  password             = random_password.password.result
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!@#$%^&*()-_=+[]{}<>:?"
}

output "rds_password" {
  value     = random_password.password.result
  sensitive = true
}