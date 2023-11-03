 data "terraform_remote_state" "vpc" {
    backend = "s3"
    config = {
        bucket = "b54-terraform-remote-state"
        key    = "vpc/${var.ENV}/terraform.tfstate"
        region = "us-east-1"
    }
   
 }

 data "terraform_remote_state" "alb" {
    backend = "s3"
    config = {
        bucket = "b54-terraform-remote-state"
        key    = "alb/${var.ENV}/terraform.tfstate"
        region = "us-east-1"
    }
   
 }
# Ensure you create an AMI  : using my lab Image {create an instance , Install ansible and make an AMI and use it}
 data "aws_ami" "image" {
  most_recent  = true
  name_regex = "ansible-lab-image"
  owners = ["self"]

  }


data "aws_secretsmanager_secret" "secrets" {
  name = "robot/secrets"
}


data "aws_secretsmanager_secret_version" "secret_version" {
  secret_id     = data.aws_secretsmanager_secret.secrets.id 
}
