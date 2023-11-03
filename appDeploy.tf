resource "null_resource" "app_deploy" {
    count   =  local.INSTANCE_COUNT

    provisioner "remote-exec" {
  
  # connection block establishes connection to this 
   connection {
    type     = "ssh"
    user     = "centos"
    password = "DevOps321"
    host     = element(local.INSTANCE_IPS , count.index)      #aws_instance.sample.private_ip : use this only if your provisioner is outside the resourcee
  }
    inline = [
        "hostname"
    #   "ansible-pull -U https://github.com/jogendra-b54/ansible.git -e ENV=dev -e COMPONENT=${var.COMPONENT} -e APP_VERSION=${var.APP_VERSION} roboshop-pull.yml",
    ]
  }

}


