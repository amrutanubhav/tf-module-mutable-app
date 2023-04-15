# Request a spot instance
resource "aws_spot_instance_request" "spot-ec2" {
  count                     = var.SPOT_INSTANCE_COUNT
  ami                       = data.aws_ami.image.id
  instance_type             = var.INSTANCE_TYPE
  subnet_id                 = element(data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS, count.index)
  vpc_security_group_ids    = [aws_security_group.sg.id]
  wait_for_fulfillment      = true

  tags = {
    Name = "${var.COMPONENT}-${var.ENV}"
  }
}


# creates on-demand instance
resource "aws_instance" "od-ec2" {
  count                   = var.OD_INSTANCE_COUNT
  ami                     = data.aws_ami.image.id
  instance_type           = var.INSTANCE_TYPE
  subnet_id               = element(data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS, count.index)
  vpc_security_group_ids  = [aws_security_group.sg.id]

  tags = {
    Name = "${var.COMPONENT}-${var.ENV}"
  }
}



#creates tags for the instance

resource "aws_ec2_tag" "spot-server-tag" {
  count       = var.SPOT_INSTANCE_COUNT + var.OD_INSTANCE_COUNT
  resource_id = element(local.ALL_INSTANCE_IDS, count.index)
  key         = "Name"
  value       = "${var.COMPONENT}-${var.ENV}"
}
