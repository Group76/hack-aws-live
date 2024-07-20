resource "aws_lb" "doctor" {
  name            = "doctor-lb"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.lb.id]
}

resource "aws_lb_target_group" "doctor" {
  name        = "ecs-doctor-target-group"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.default.id
  target_type = "ip"

   health_check {
   enabled = true
   path = "/health"
 }
}

resource "aws_lb_listener" "doctor" {
  load_balancer_arn = aws_lb.doctor.id
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.doctor.id
    type             = "forward"
  }
}