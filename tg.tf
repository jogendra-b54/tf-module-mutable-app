# Creates Target Group for the backend Components 
resource "aws_lb_target_group" "app" {
  name     = "${var.COMPONENT}-${var.ENV}-tg"
  port     = var.APP_PORT
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.vpc.outputs.VPC_ID
  health_check {
        enabled             =   true 
        healthy_threshold   = 2
        interval            =  5
        timeout             = 4
        path                = "/health"
        unhealthy_threshold = 2
        
  }
}


# Adds the instances to the Target Group
resource "aws_lb_target_group_attachment" "attach_instances" {
 
  count               =  local.INSTANCE_COUNT
  target_group_arn    = aws_lb_target_group.app.arn
  target_id           = element(local.INSTANCE_IDS,count.index) 
  port                = 8080
}

# Cretes rule in the Listener
resource "aws_lb_listener_rule" "app_rule" {
  listener_arn = data.terraform_remote_state.alb.outputs.PRIVATE_LISTENER_ARN
  priority     = 100 

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  condition {
    host_header {
      values = ["${var.COMPONENT}-${var.ENV}.${data.terraform_remote_state.vpc.outputs.PRIVATE_HOSTED_ZONE_NAME}"]
    }
  }
}
# Attach the Target group to the ALB ( frontend TG should be attached to public ALB and backend TG should attah to private ALB)