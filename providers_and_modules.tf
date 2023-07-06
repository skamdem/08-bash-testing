# list of providers and modules

provider "aws" {
  region = var.region
}

data "aws_ami" "ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
}

module "say_hello" {
  source = "./modules/hello_module"

  # Input variables
  instance_type   = var.module_instance_type
  instance_ami_id = data.aws_ami.ami.image_id
}

output "url" {
  value = "http://${module.say_hello.server_public_ip}:8080"
}