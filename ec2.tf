#Create AWS EC2 SPOT INSTANCE
resource "aws_spot_instance_request" "spot" {

  count                  = var.SPOT_INSTANCE_COUNT

  ami                    = data.aws_ami.image.id
  instance_type          = var.SPOT_INSTANCE_TYPE
  vpc_security_group_ids = [aws_security_group.allows_app.id]
  subnet_id              = element(data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS , count.index)
  wait_for_fulfillment = true
  iam_instance_profile = "b54-admin"

    # This creates Tag name to the spot request not to the spot ec2 instance
  tags = {
    Name = "${var.COMPONENT}-${var.ENV}"
  }
}

# Creating tag and attaching it to the instances

# Create on-Demand Backend Components
resource "aws_instance" "od" {
  
   count         = var.OD_INSTANCE_COUNT
   ami           =  data.aws_ami.image.id
   instance_type = var.OD_INSTANCE_TYPE
   vpc_security_group_ids = [aws_security_group.allows_app.id]
   subnet_id              = element(data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS , count.index)

  iam_instance_profile = "b54-admin"

  tags = {
    Name       = "${var.COMPONENT}-${var.ENV}"
    //prometheus-monitor =
  }


  
}


resource "aws_ec2_tag" "tags" {

    count       = local.INSTANCE_COUNT


  //resource_id = [OD Instance instanceID + SPOT Instance IDs]
  resource_id = element(local.INSTANCE_IDS , count.index)
  key         = "Name"
  value       = "${var.COMPONENT}-${var.ENV}"
}