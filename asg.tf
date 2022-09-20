# 테라폼은 리소스를 삭제한 다음 생성하지만 min_size 때문에 에러가 발생합니다.
# 이는 테라폼의 lifecycle를 통해서 업데이트 할 수 있습니다.
# create_before_destroy = true로 하면 생성후 삭제 작업을 합니다.
resource "aws_launch_configuration" "example_launch_conf" {
    image_id = "ami-0da7e599a50c34e68"
    instance_type = "t2.micro"
    security_groups = [ aws_security_group.security_group.id ]
    lifecycle {
        create_before_destroy =true
    }
}

variable "server_port" {
    description = "server port"
    default = 80
}

resource "aws_security_group" "security_group" {
    name = "default_instance_security_group"
    vpc_id = aws_vpc.oterrafrom_study_vpc.id
    ingress {
        from_port = var.server_port
        to_port = var.server_port
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
}

resource "aws_autoscaling_group" "auto_scaling_group" {
    launch_configuration = aws_launch_configuration.example_launch_conf.name
    vpc_zone_identifier = [aws_subnet.oterraform_study_public1.id , aws_subnet.oterraform_study_public2.id ]
    min_size = 2
    max_size = 4

    target_group_arns = [ aws_lb_target_group.asg.arn ]
    health_check_type = "ELB"

    tag {
        key = "Name"
        value = "oterrform AutoScailing Group"
        propagate_at_launch = true
    }
}

# data는 aws 에서 필요한 정보를 가져오는 역할읗 합니다.
# data.aws_vpc.vpc_data.id 와 같은 방법으로 참조를 진행합니다.
data "aws_vpc" "vpc_data" {
    default = true
}
data "aws_subnets" "vpc_subnet" {
    filter {
        name = "vpc-id"
        values = [ aws_vpc.oterrafrom_study_vpc.id ]
    }
}


# 이러한 오토 스케일링 그룹을 관리하기 위해서는 로그 밸런서를 사용합니다.
# 간단한 웹서버 그룹이기 때문에 L7 레이어인 ALB를 이용해서 조작합니다.
resource "aws_lb" "lb" {
    
    name = "oterraform-asg-example"
    load_balancer_type = "application"
    subnets = [
        aws_subnet.oterraform_study_private1.id,
        aws_subnet.oterraform_study_private2.id,
        aws_subnet.oterraform_study_public1.id,
        aws_subnet.oterraform_study_public2.id
    ]
    security_groups = [ aws_security_group.security_group.id ]
}

# 또한 로드밸런서의 리스너를 지정해 주어야 합니다.
resource "aws_lb_listener" "lb_listener" {
    load_balancer_arn = aws_lb.lb.arn
    port = 80
    protocol = "HTTP"

    # 기본값으로는 404 페이지 오류를 반환합니다.
    default_action {
        type = "fixed-response"
        fixed_response {
            content_type = "text/plain"
            message_body = "404: page not found"
            status_code = 404
        }
    }
}

resource "aws_lb_target_group" "asg" {
    name = "oterraform-asg-example"
    port = var.server_port
    protocol = "HTTP"
    vpc_id = aws_vpc.oterrafrom_study_vpc.id
    health_check {
        path = "/"
        protocol = "HTTP"
        matcher = "200"
        interval = 15
        timeout = 3
        healthy_threshold = 2
        unhealthy_threshold = 2
    }
}


resource "aws_lb_listener_rule" "aws_lb_listener" {
    listener_arn = aws_lb_listener.lb_listener.arn
    priority = 100

    condition {
        path_pattern {
            values = ["*"]
        }
    }

    action {
        type = "forward"
        target_group_arn = aws_lb_target_group.asg.arn
    }
}

output "alb_dns_name" {
    value = aws_lb.lb.dns_name
    description = "alb_dns_name"
}