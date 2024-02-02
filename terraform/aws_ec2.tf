locals {
  instances = {
    puppet_server = {
      ami_id                      = "ami-02fe204d17e0189fb"
      instance_type               = "t2.micro"
      subnet_id                   = aws_subnet.main["public"].id
      associate_public_ip_address = true
    }
    elk_stash_server = {
      ami_id                      = "ami-02fe204d17e0189fb"
      instance_type               = "t2.micro"
      subnet_id                   = aws_subnet.main["private"].id
      associate_public_ip_address = false
    }
  }
}

resource "aws_security_group" "main" {
  for_each    = local.instances
  name        = format("%s-ec2-security-group", each.key)
  description = format("Default Security Group for %s EC2 instance", each.key)
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = format("%s-ec2-security-group", each.key)
  }
}


resource "aws_instance" "main" {
  for_each                    = local.instances
  ami                         = each.value.ami_id
  instance_type               = each.value.instance_type
  subnet_id                   = each.value.subnet_id
  associate_public_ip_address = each.value.associate_public_ip_address
  security_groups = [
    aws_security_group.main[each.key].id
  ]
  tags = {
    Name = format("%s-ec2-instance", each.key)
  }
}
