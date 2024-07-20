resource "aws_lb" "doctor_auth" {
  name            = "doctor-auth-lb"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.lb.id]
}

resource "aws_lb_target_group" "doctor_auth" {
  name        = "ecs-doctor-auth-target-group"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.default.id
  target_type = "ip"

   health_check {
   enabled = true
   path = "/health"
 }
}

resource "aws_lb_listener" "doctor_auth" {
  load_balancer_arn = aws_lb.doctor_auth.id
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.doctor_auth.id
    type             = "forward"
  }
}