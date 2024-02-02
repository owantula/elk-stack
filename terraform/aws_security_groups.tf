locals {
  ingress_rules = {
    puppet-server-ssh-from-internet = {
      description                  = "Allow SSH traffic from internet to the puppet-server"
      ip_protocol                  = "tcp"
      from_port                    = 22
      to_port                      = 22
      security_group_id            = aws_security_group.main["puppet-server"].id
      cidr_ipv4                    = "0.0.0.0/0"
      referenced_security_group_id = null
    }
    elk-stash-ssh-from-puppet-server = {
      description                  = "Allow SSH traffic to the elk-stash from puppet-server"
      ip_protocol                  = "tcp"
      from_port                    = 22
      to_port                      = 22
      security_group_id            = aws_security_group.main["elk-stash"].id
      cidr_ipv4                    = null
      referenced_security_group_id = aws_security_group.main["puppet-server"].id
    }
  }
  egress_rules = {
    puppet-server-to-elk-stash-ssh = {
      description                  = "Allow SSH traffic from the puppet-server to the elk-stash"
      ip_protocol                  = "tcp"
      from_port                    = 22
      to_port                      = 22
      security_group_id            = aws_security_group.main["puppet-server"].id
      cidr_ipv4                    = null
      referenced_security_group_id = aws_security_group.main["elk-stash"].id
    }
  }
}


resource "aws_vpc_security_group_ingress_rule" "main" {
  for_each                     = local.ingress_rules
  description                  = each.value.description
  ip_protocol                  = each.value.ip_protocol
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  security_group_id            = each.value.security_group_id
  cidr_ipv4                    = each.value.cidr_ipv4
  referenced_security_group_id = each.value.referenced_security_group_id
}

resource "aws_vpc_security_group_egress_rule" "main" {
  for_each                     = local.egress_rules
  description                  = each.value.description
  ip_protocol                  = each.value.ip_protocol
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  security_group_id            = each.value.security_group_id
  cidr_ipv4                    = each.value.cidr_ipv4
  referenced_security_group_id = each.value.referenced_security_group_id
}
