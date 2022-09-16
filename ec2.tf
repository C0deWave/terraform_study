#ami-01d87646ef267ccd7
resource "aws_instance" "first_instance" {
    ami = "ami-01d87646ef267ccd7"
    instance_type = "t2.micro"
    tags = {
        "Name" = "terraform-day24"
    }
    user_data = <<-EOF
                   #! /bin/bash
                   echo "Hello world" > index.html
                   nohup busybox httpd -f -p 8080 &
    EOF
    
    vpc_security_group_ids = [ aws_security_group.security_group.id ]
}

resource "aws_security_group" "security_group" {
    name = "default_instance_security_group"
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
  
}