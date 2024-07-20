resource "aws_ecr_repository" "ecr-doctor" {
  name = "doctor-ecr-repository"
  image_tag_mutability = "MUTABLE"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }
}