#Create AWS EC2 SPOT INSTANCE
resource "aws_spot_instance_request" "spot" {

  count                  = var.SPOT_INSTANCE_COUNT

  ami                    = data.aws_ami.image.id
  instance_type          = var.SPOT_INSTANCE_TYPE
  vpc_security_group_ids =
  wait_for_fulfillment = true

  tags = {
    Name = ${var.COMPONENT}-${var.ENV}
  }
}

# Create on-Demand Backend Components
resource "aws_instance" "od" {
  
   count         = var.OD_INSTANCE_COUNT
   ami           =  data.aws_ami.image.id
   instance_type = var.OD_INSTANCE_TYPE
   vpc_security_group_ids = 
    


# This will be executed  on the top of the machine once its created ....
#  provisioner "remote-exec" {
#   # connection block establishes connection to this 
#   connection {
#     type     = "ssh"
#     user     = "centos"
#     password = "DevOps321"
#     host     = self.private_ip      #aws_instance.sample.private_ip : use this only if your provisioner is outside the resourcee
#   }
#     inline = [
#       "ansible-pull -U https://github.com/jogendra-b54/ansible.git -e ENV=dev -e COMPONENT=${var.COMPONENT} -e APP_VERSION=${var.APP_VERSION} roboshop-pull.yml",
#     ]
#   }

# }

# variable "sg" {}   # step 3: now to use this infor, declare an empty variable and use it (in root module , we have declared "sg=var.sgid")


# output "public_ip" {
#   value = aws_instance.sample.public_ip
# }

}