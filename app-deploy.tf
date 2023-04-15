resource "null_resource" "app" {
  
   provisioner "remote-exec" {

        connection {
          type     = "ssh"
          user     = local.SSH_USER
          password = local.SSH_PASS
          host     = element(local.ALL_INSTANCE_IPS, count.index)
        }

              inline = [
                "ansible-pull -U https://github.com/amrutanubhav/robohop-plays.git -e component=mongodb -e env=dev robot-pull.yml"
              ]

 
  }
}