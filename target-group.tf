#creates TG
resource "aws_lb_target_group" "app-tg" {
  name        = "${var.COMPONENT}-${var.ENV}"
  port        = var.PORT
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID

    health_check {

    path = "/health"
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 4
    interval = 5
    enabled = true
    
  }

}

##Attaching the instances to the created TG
resource "aws_lb_target_group_attachment" "instanc-attach" {
  count            = var.SPOT_INSTANCE_COUNT + var.OD_INSTANCE_COUNT
  target_group_arn = aws_lb_target_group.app-tg.arn
  target_id        = element(local.ALL_INSTANCE_IDS, count.index)
  port             = var.PORT
}

#backend components TG need to be attached to private alb and frontend TG needs to be attached to public alb

#generates random priority

resource "random_integer" "priority" {
  min = 100
  max = 800
}

#adding rules to the created public target group

resource "aws_lb_listener_rule" "private-tg-rule" {
  count        = var.ALB_TYPE == "internal" ? 1 : 0
  listener_arn = data.terraform_remote_state.alb.outputs.PRIVATE_LISTENER_ARN
  priority     = random_integer.priority.result

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-tg.arn
  }

  condition {
    host_header {
      values = ["${var.COMPONENT}-${var.ENV}.${data.terraform_remote_state.vpc.outputs.PRIVATE_HOSTEDZONE_NAME}"]
    }
  }
}


#create listener for public LB
resource "aws_lb_listener" "public" {
  count             = var.ALB_TYPE == "internal" ? 0 : 1
  load_balancer_arn = data.terraform_remote_state.alb.outputs.PUBLIC_ALB_ARN
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-tg.arn
  }
}