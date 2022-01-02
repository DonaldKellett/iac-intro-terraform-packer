# iac-intro-terraform-packer

Assets for the [Introduction to Infrastructure as Code with Terraform and Packer](https://dev.to/donaldsebleung/introduction-to-infrastructure-as-code-with-terraform-and-packer-10cl) article on Dev.to

## Quick start

### Prerequisites

It is assumed you already have an AWS account, and AWS CLI v2 installed and set up with an IAM user with sufficient permissions to manage EC2-related resources. If not, [create an AWS account](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/) and [set up the CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html). Alternatively, follow through [this AWS CLI introduction I wrote](https://dev.to/donaldsebleung/introduction-to-the-aws-cli-e6o) ;-)

### Setup

Install [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) and [Packer](https://learn.hashicorp.com/tutorials/packer/get-started-install-cli). This should take you no more than a minute.

Now clone this repo and `cd` into it:

```bash
$ git clone https://github.com/DonaldKellett/iac-intro-terraform-packer.git && cd iac-intro-terraform-packer
```

### Provision a fresh Ubuntu 20.04 EC2 instance with Terraform and SSH into it

Move into the `ec2-basic` directory:

```bash
$ cd ec2-basic
```

In the file `key-pair.tf`, replace the public key material with your own. Check `$HOME/.ssh/id_rsa.pub` if you think you may not have a key pair. If the aforementioned file doesn't exist, create a key pair with `ssh-keygen`.

Initialize the project and apply the configuration files:

```bash
$ terraform init
$ terraform apply
```

Answer `yes` when prompted. Wait a few moments for the resources to be created. In the end, a public IP should be printed to the console. Save that in an environment variable `EC2_PUBLIC_IP`. Now SSH to the instance:

```bash
$ ssh ubuntu@"$EC2_PUBLIC_IP"
```

Play around a bit. When done, exit the SSH session:

```bash
$ exit
logout
Connection to x.x.x.x closed
```

Tear down the infrastructure (answer `yes` when prompted):

```bash
$ terraform destroy
```

Go back up one level:

```bash
$ cd ..
```

### Provision a custom EC2 instance with HTTPS web server with Terraform and visit the website

Move into the `ec2-website` directory:

```bash
$ cd ec2-website
```

Again, replace the public key in `key-pair.tf` with your own. Initialize and apply:

```bash
$ terraform init
$ terraform apply
```

After the instance is up and the public IP is printed to the console, wait for a minute or two for some setup scripts to complete. Then, assuing your public IP is `x.x.x.x`, visit https://x.x.x.x in a browser and ignore warnings about a self-signed certificate. You should see my website in action (-:

Tear down:

```bash
$ terraform destroy
```

Go back up one level:

```bash
$ cd ..
```

### Bake a custom AMI with Packer, provision an instance with custom AMI with Terraform

Move into `ec2-custom-packer`:

```bash
$ cd ec2-custom-packer
```

Initialize the current directory and build the AMI:

```bash
$ packer init .
$ packer build .
```

In the end, you should see an AMI ID printed to the console. Save it in an environment variable `CUSTOM_AMI_ID`.

Print out the environment variable and copy the AMI ID:

```bash
$ echo $CUSTOM_AMI_ID
ami-xxxxxxxx
```

Move to the adjacent `ec2-custom-terraform` directory:

```bash
$ cd ../ec2-custom-terraform
```

Again, replace the public key in `key-pair.tf` with your own. Also replace the AMI ID in `instance.tf` with your own.

Initialize and apply:

```bash
$ terraform init
$ terraform apply
```

When the public IP of the instance is printed to console, visit that public IP in your browser again using HTTPS, ignoring warnings about a self-signed certificate.

Tear down:

```bash
$ terraform destroy
```

Finally, de-register your custom AMI:

```bash
$ aws ec2 deregister-image --image-id "$CUSTOM_AMI_ID"
```

## License

[MIT](./LICENSE)
