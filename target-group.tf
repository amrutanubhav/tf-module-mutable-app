#creates TG
resource "aws_lb_target_group" "app-tg" {
  name        = "${var.COMPONENT}-${var.ENV}"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID
}

##Attaching the instances to the created TG
resource "aws_lb_target_group_attachment" "instanc-attach" {
  count            = var.SPOT_INSTANCE_COUNT + var.OD_INSTANCE_COUNT
  target_group_arn = aws_lb_target_group.app-tg.arn
  target_id        = element(local.ALL_INSTANCE_IDS, count.index)
  port             = 8080
}

#backend components TG need to be attached to private alb and frontend TG needs to be attached to public alb

# adding rules to the target group

resource "aws_lb_listener_rule" "app-rule" {
  listener_arn = data.terraform_remote_state.alb.outputs.PRIVATE_LISTENER_ARN
  priority     = random_integer.priority.result

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-tg.arn
  }

  condition {
    host_header {
      values = ["${var.COMPONENT}- ${var.ENV}.${data.terraform_remote_state.vpc.outputs.PRIVATE_HOSTEDZONE_NAME}"]
    }
  }
}

#generates random priority

resource "random_integer" "priority" {
  min = 100
  max = 800
}
