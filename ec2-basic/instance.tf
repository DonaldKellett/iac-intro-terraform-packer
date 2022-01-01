resource "aws_instance" "ec2_basic" {
  ami = "ami-00056a28d6c5e916b"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ec2_basic.id]
  key_name = aws_key_pair.macbook_air_ubuntu.key_name
}
