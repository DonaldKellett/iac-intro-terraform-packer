resource "aws_instance" "ec2_basic" {
  ami = "ami-00056a28d6c5e916b"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ec2_basic.id]
  key_name = aws_key_pair.macbook_air_ubuntu.key_name
  user_data = <<EOT
#!/bin/bash

apt-get update
apt-get install -y software-properties-common
yes "" | add-apt-repository ppa:donaldsebleung/misc
apt-get update
apt-get install -y donaldsebleung-com
yes "" | openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -sha256 -days 365 -nodes
mv key.pem /etc/donaldsebleung-com
mv cert.pem /etc/donaldsebleung-com
systemctl enable --now donaldsebleung-com.service
EOT
}
