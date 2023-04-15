#fetch info from remote statefile ie:vpc satefile

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "b52-terraform-bucket"
    key    = "vpc/${var.ENV}/terraform.tfstate"
    region = "us-east-1"
  }
}


#fetch info from remote statefile tf-alb backend module
data "terraform_remote_state" "alb" {
  backend = "s3"

  config = {
    bucket = "b52-terraform-bucket"
    key    = "alb/${var.ENV}/terraform.tfstate"
    region = "us-east-1"
  }
}

#data for the ami
data "aws_ami" "image" {
  most_recent      = true
  name_regex       = "b52-ansible-dev-20Jan2023"
  owners           = ["355449129696"]
}

data "aws_secretsmanager_secret" "secrets" {
  name = "roboshop/secrets"
}


data "aws_secretsmanager_secret_version" "secrets" {
  secret_id = data.aws_secretsmanager_secret.secrets.id
}