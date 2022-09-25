resource "aws_instance" "test_instance" {
  ami="ami-0da7e599a50c34e68"
  instance_type = terraform.workspace == "default" ? "t2.small" : "t2.micro"
}