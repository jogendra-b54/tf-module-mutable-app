resource "null_resource" "app_deploy" {
  triggers = {
        always_run = timestamp() // whenever you deply a nwe change in runs because it compares the time as everytume you deploy a new timestamp will create
       #APP_VERSION = var.APP_VERSION   // whenver there is a change in the version then the tigger should run
  }

    count   =  local.INSTANCE_COUNT
    provisioner "remote-exec" {
  
  # connection block establishes connection to this 
   connection {
    type     = "ssh"
    user     = local.SSH_USER
    password = local.SSH_PASS
    host     = element(local.INSTANCE_IPS , count.index)      #aws_instance.sample.private_ip : use this only if your provisioner is outside the resourcee
  }
    inline = [
         "ansible-pull -U https://github.com/jogendra-b54/ansible.git -e MONGODB_ENDPOINT=${data.terraform_remote_state.db.outputs.MONGODB_ENDPOINT} -e ENV=dev -e COMPONENT=${var.COMPONENT} -e APP_VERSION=${var.APP_VERSION} roboshop-pull.yml",
    ]
  }

}


