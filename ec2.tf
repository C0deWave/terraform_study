#variable "server_port" {
#    type = number
#    description = "서버 포트값"
#    default = 80
#}
#
#resource "aws_instance" "first_instance" {
#    ami = "ami-0da7e599a50c34e68"
#    instance_type = "t2.micro"
#    tags = {
#        "Name" = "terraform-day24"
#    }
#    #user_data = <<-EOF
#    #                #!/bin/bash
#    #                yum update -y
#    #                yum install -y httpd.x86_64
#    #                systemctl start httpd.service
#    #                systemctl enable httpd.service
#    #                echo “Hello World from $(hostname -f)” > /var/www/html/index.html
#    #EOF
#    
#    vpc_security_group_ids = [ aws_security_group.security_group.id ]
#}
#
#resource "aws_security_group" "security_group" {
#    name = "default_instance_security_group"
#    ingress {
#        from_port = var.server_port
#        to_port = var.server_port
#        protocol = "tcp"
#        cidr_blocks = [ "0.0.0.0/0" ]
#    }
#  egress {
#    from_port        = 0
#    to_port          = 0
#    protocol         = "-1"
#    cidr_blocks      = ["0.0.0.0/0"]
#    ipv6_cidr_blocks = ["::/0"]
#  }
#}
#
#output "server_ip" {
#    description = "web server ip"
#    value = aws_instance.first_instance.public_ip
#}