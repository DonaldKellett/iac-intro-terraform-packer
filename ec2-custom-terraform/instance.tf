resource "aws_instance" "ec2_basic" {
  ami = "ami-0cf4e6ec23e69dd66"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ec2_basic.id]
  key_name = aws_key_pair.macbook_air_ubuntu.key_name
}
