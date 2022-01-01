output "ec2_basic_public_ip" {
  description = "Public IP of our created instance"
  value = aws_instance.ec2_basic.public_ip
}
