# Load Balancer / Listeners / Target Groups
resource "aws_lb_target_group" "wordpress" {
  port      = 80
  protocol  = "HTTP"
  vpc_id    = data.terraform_remote_state.dsf.outputs.vpc_id

  health_check {
    path    = "/"
    matcher = "200-299"
  }
}

resource "aws_lb_target_group_attachment" "wordpress" {
  target_group_arn  = aws_lb_target_group.wordpress.arn
  target_id         = aws_instance.wordpress.id
  port              = 80

  depends_on = [
    aws_instance.wordpress,
    aws_lb_target_group.wordpress
  ]
}

resource "aws_lb_listener_rule" "wordpress" {
  listener_arn      = data.terraform_remote_state.dsf.outputs.alb_listener_https_arn
  priority          = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress.arn
  }

  condition {
    host_header {
      values = [
        "www.digitalsloth.com"
      ]
    } 
  }
}