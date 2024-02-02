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
