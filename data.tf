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