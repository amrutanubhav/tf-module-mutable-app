resource "null_resource" "app" {
  
   provisioner "remote-exec" {

        connection {
          type     = "ssh"
          user     = local.SSH_USER
          password = local.SSH_PASS
          host     = element(local.ALL_INSTANCE_IPS, count.index)
        }

              inline = [
                "ansible-pull -U https://github.com/amrutanubhav/robohop-plays.git -e component=${var.COMPONENT} -e env=${var.ENV} APP_VERSION=${var.APP_VERSION} -e robot-pull.yml"
              ]

 
  }
}