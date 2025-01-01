
resource "aws_lb_target_group" "jenkins_target_group" {
  name     = "${var.alb_name}-jenkins-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/login"
    port                = "8080"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = "${var.alb_name}-jenkins-tg"
  }
}

resource "aws_lb_target_group" "app_target_group" {
  name     = "${var.alb_name}-app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = "${var.alb_name}-app-tg"
  }
}

resource "aws_lb_target_group_attachment" "jenkins_tg_attachment" {
  target_group_arn = aws_lb_target_group.jenkins_target_group.arn
  target_id        = var.instance_id_jenkins
  port             = 8080
}

resource "aws_lb_target_group_attachment" "app_tg_attachment" {
  target_group_arn = aws_lb_target_group.app_target_group.arn
  target_id        = var.instance_id_app
  port             = 80
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = var.alb_arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins_target_group.arn
  }
}

resource "aws_lb_listener" "http_listener_app" {
  load_balancer_arn = var.alb_arn
  port              = 3000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_target_group.arn
  }
}


resource "aws_lb_listener_rule" "jenkins_path_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["/jenkins*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins_target_group.arn
  }

}

resource "aws_lb_listener_rule" "app_path_rule" {
  listener_arn = aws_lb_listener.http_listener_app.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["/app*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_target_group.arn
  }

}


