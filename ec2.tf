#ami-01d87646ef267ccd7
resource "aws_instance" "first_instance" {
  ami = "ami-01d87646ef267ccd7"
  instance_type = "t2.micro"
  tags = {
    "Name" = "terraform-day24"
  }
}