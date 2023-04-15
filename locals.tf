locals {
  ALL_INSTANCE_IDS = concat(aws_spot_instance_request.spot-ec2.*.spot_instance_id,aws_instance.od-ec2.*.id)
  ALL_INSTANCE_IPS = concat(aws_spot_instance_request.spot-ec2.*.private_ip,aws_instance.od-ec2.*.private_ip)
  SSH_PASS         = jsondecode(data.aws_secretsmanager_secret_version.secrets.secret_string)["SSH_PASSWORD"]
  SSH_USER         = jsondecode(data.aws_secretsmanager_secret_version.secrets.secret_string)["SSH_USER"]
}