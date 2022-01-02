packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "ami_prefix" {
  type    = string
  default = "donaldsebleung-com"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "donaldsebleung-com" {
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami    = "ami-008569888adb8f3e8"
  ssh_username  = "ubuntu"
}

build {
  sources = ["source.amazon-ebs.donaldsebleung-com"]
  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y software-properties-common",
      "yes \"\" | sudo add-apt-repository ppa:donaldsebleung/misc",
      "sudo apt-get update",
      "sudo apt-get install -y donaldsebleung-com",
      "yes \"\" | openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -sha256 -days 365 -nodes",
      "sudo mv key.pem /etc/donaldsebleung-com",
      "sudo mv cert.pem /etc/donaldsebleung-com",
      "sudo systemctl enable --now donaldsebleung-com.service"
    ]
  }
}
