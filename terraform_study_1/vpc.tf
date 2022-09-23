resource "aws_vpc" "oterrafrom_study_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        "Name" = "oterraform_study"
    }
}

resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.oterrafrom_study_vpc.id
    tags = {
        Name = "main"
    }
}

resource "aws_subnet" "oterraform_study_public1" {
    vpc_id     = aws_vpc.oterrafrom_study_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-northeast-2a"
    tags = {
        Name = "oterraform_study_public1"
    }
}
resource "aws_subnet" "oterraform_study_public2" {
    vpc_id     = aws_vpc.oterrafrom_study_vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "ap-northeast-2c"
    tags = {
        Name = "oterraform_study_public2"
    }
}


resource "aws_subnet" "oterraform_study_private1" {
    vpc_id     = aws_vpc.oterrafrom_study_vpc.id
    cidr_block = "10.0.3.0/24"
    availability_zone = "ap-northeast-2b"
    tags = {
        Name = "oterraform_study_private1"
    }
}
resource "aws_subnet" "oterraform_study_private2" {
    vpc_id     = aws_vpc.oterrafrom_study_vpc.id
    cidr_block = "10.0.4.0/24"
    availability_zone = "ap-northeast-2d"
    tags = {
        Name = "oterraform_study_private2"
    }
}

output "subnet_cidr_blocks" {
  value = [
    aws_subnet.oterraform_study_private1.cidr_block,
    aws_subnet.oterraform_study_private2.cidr_block,
    aws_subnet.oterraform_study_public1.cidr_block,
    aws_subnet.oterraform_study_public2.cidr_block
  ]
}
