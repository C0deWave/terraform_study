# variable는 변수입니다.
# 

# 일반 변수 선언
#variable "number_example" {
#    description = "설명을 적습니다."
#    type = number
#    default = 20
#}

# 리스트와 맵
#variable "list_number_example" {
#    description = "list of number_example"
#    type = list(number)
#    default = [ 1, 2, 3 ]
#}

#variable "map_example" {
#    description = "map example"
#    type = map(string)
#    default = {
#        "key" = "value"
#    }
#}

# 좀더 복잡한 구조의 변수 선언
# 오브젝트로 변수 선언
#variable "object_example" {
#    description = "object"
#    type = object({
#        name = string
#        age = number
#        tags = list(string)
#        enabled = bool
#    })
#    default = {
#        age = 1
#        enabled = false
#        name = "value"
#        tags = [ "value" ]
#    }
#}

# 웹서버 포트 예제
# default를 지정하지 않으면 terraform plan시 포트번호를 물어봅니다.
# 대화식으로 하고 싶지 않으면 -var옵션으로 명시합니다.
# terraform plan -var "server_port=8080" ==> 대신 환경변수 TF_VAR_server_port로도 가능합니다.
#variable "server_port" {
#    description = "서버 포트입니다."
#    type = number
#}

#이는 아래와 같이 참조 합니다.
#resource "aws_security_group" "security_group2" {
#    name = "default_instance_security_group"
#    ingress {
#        from_port = var.server_port
#        to_port = var.server_port
#        protocol = "tcp"
#        cidr_blocks = [ "0.0.0.0/0" ]
#    } 
#}

# 문자열 내에서는 다음과 같이 선언합니다.
#resource "aws_instance" "first_instance2" {
#    ami = "ami-01d87646ef267ccd7"
#    instance_type = "t2.micro"
#    tags = {
#        "Name" = "terraform-day24"
#    }
#    user_data = <<-EOF
#                    #! /bin/bash
#                    echo "Hello world" > index.html
#                    nohup busybox httpd -f -p ${var.server_port} &
#    EOF
#    vpc_security_group_ids = [ aws_security_group.security_group.id ]
#}

#------------------------------------------------------------------------
# 위의 변수는 일종의 입력값입니다.
# 이번에는 출력값을 지정해 봅시다.
#output "output_example" {
#    description = "퍼블릭 아이피 값입니다."
#    sensitive = false  # true로 하면 민감정보의 경우 tfstate에 저장하지 않고 plan이나 apply 시에만 값을 보여줍니다.
#    value = aws_instance.first_instance2.public_ip
#}

# 이런 output은 plan이나 apply 시 맨 아래 값을 보여줍니다.
# 또는 terraform output을 이용하면 tfstate에 저장된 결과값을 볼 수 있습니다.
# terraform output output_example 명령과 같이 특정 값만 볼수도 있습니다.
# 이는 추후에 스크립트를 통해 curl을 날리는 등의 테스트를 할때 유용합니다.