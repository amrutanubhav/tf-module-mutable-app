locals {
  ALL_INSTANCE_IDS = concat(aws_spot_instance_request.spot-ec2.*.spot_instance_id,aws_instance.od-ec2.*.id)
}