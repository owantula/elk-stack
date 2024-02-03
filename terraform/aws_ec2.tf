locals {
  instances = {
    kibana = {
      ami_id                      = "ami-0faab6bdbac9486fb"
      instance_type               = "t2.medium"
      subnet_id                   = aws_subnet.main["public"].id
      associate_public_ip_address = true
    }

    elasticsearch = {
      ami_id                      = "ami-0faab6bdbac9486fb"
      instance_type               = "t2.medium"
      subnet_id                   = aws_subnet.main["private"].id
      associate_public_ip_address = true
    }

    logstash = {
      ami_id                      = "ami-0faab6bdbac9486fb"
      instance_type               = "t2.medium"
      subnet_id                   = aws_subnet.main["private"].id
      associate_public_ip_address = true
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

resource "aws_key_pair" "main" {
  key_name   = "ow-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFAACIU2QZV7O6ziOyqFHGi+swflE18DLiP78NyT/ELt ondrej.wantula@gmail.com"
}


resource "aws_instance" "main" {
  for_each                    = local.instances
  ami                         = each.value.ami_id
  instance_type               = each.value.instance_type
  subnet_id                   = each.value.subnet_id
  associate_public_ip_address = each.value.associate_public_ip_address
  key_name                    = aws_key_pair.main.key_name
  vpc_security_group_ids = [
    aws_security_group.main[each.key].id
  ]
  tags = {
    Name = format("%s-ec2-instance", each.key)
  }
}

resource "aws_eip" "kibana" {
  domain   = "vpc"
  instance = aws_instance.main["kibana"].id
}
