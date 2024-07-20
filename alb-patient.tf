resource "aws_lb" "patient" {
  name            = "patient-lb"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.lb.id]
}

resource "aws_lb_target_group" "patient" {
  name        = "ecs-patient-target-group"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.default.id
  target_type = "ip"

   health_check {
   enabled = true
   path = "/health"
 }
}

resource "aws_lb_listener" "patient" {
  load_balancer_arn = aws_lb.patient.id
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.patient.id
    type             = "forward"
  }
}