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

    puppet-server-puppet-communication-from-elk-stash = {
      description                  = "Allow puppet traffic to the puppet-server from elk-stack"
      ip_protocol                  = "tcp"
      from_port                    = 8140
      to_port                      = 8140
      security_group_id            = aws_security_group.main["puppet-server"].id
      cidr_ipv4                    = null
      referenced_security_group_id = aws_security_group.main["elk-stash"].id
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

    elk-stash-puppet-communication-from-puppet-server = {
      description                  = "Allow puppet traffic to the elk-stash from puppet-server"
      ip_protocol                  = "tcp"
      from_port                    = 8140
      to_port                      = 8140
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
    puppet-server-to-internet-http = {
      description                  = "Allow http traffic from the puppet-server to the internet"
      ip_protocol                  = "tcp"
      from_port                    = 80
      to_port                      = 80
      security_group_id            = aws_security_group.main["puppet-server"].id
      cidr_ipv4                    = "0.0.0.0/0"
      referenced_security_group_id = null
    }
    puppet-server-to-internet-https = {
      description                  = "Allow https traffic from the puppet-server to the internet"
      ip_protocol                  = "tcp"
      from_port                    = 443
      to_port                      = 443
      security_group_id            = aws_security_group.main["puppet-server"].id
      cidr_ipv4                    = "0.0.0.0/0"
      referenced_security_group_id = null
    }

    puppet-server-to-internet-icmp = {
      description                  = "Allow https traffic from the puppet-server to the internet"
      ip_protocol                  = "icmp"
      from_port                    = 0
      to_port                      = 65535
      security_group_id            = aws_security_group.main["puppet-server"].id
      cidr_ipv4                    = "0.0.0.0/0"
      referenced_security_group_id = null
    }

    puppet-server-puppet-communication-from-elk-stash = {
      description                  = "Allow puppet traffic to the elk-stack from puppet-srver"
      ip_protocol                  = "tcp"
      from_port                    = 8140
      to_port                      = 8140
      security_group_id            = aws_security_group.main["puppet-server"].id
      cidr_ipv4                    = null
      referenced_security_group_id = aws_security_group.main["elk-stash"].id
    }

    elk-stash-to-internet-http = {
      description                  = "Allow http traffic from the elk-stash to the internet"
      ip_protocol                  = "tcp"
      from_port                    = 80
      to_port                      = 80
      security_group_id            = aws_security_group.main["elk-stash"].id
      cidr_ipv4                    = "0.0.0.0/0"
      referenced_security_group_id = null
    }
    elk-stash-to-internet-https = {
      description                  = "Allow https traffic from the elk-stash to the internet"
      ip_protocol                  = "tcp"
      from_port                    = 443
      to_port                      = 443
      security_group_id            = aws_security_group.main["elk-stash"].id
      cidr_ipv4                    = "0.0.0.0/0"
      referenced_security_group_id = null
    }

    elk-stash-to-internet-icmp = {
      description                  = "Allow https traffic from the puppet-server to the internet"
      ip_protocol                  = "icmp"
      from_port                    = 0
      to_port                      = 65535
      security_group_id            = aws_security_group.main["elk-stash"].id
      cidr_ipv4                    = "0.0.0.0/0"
      referenced_security_group_id = null
    }

    elk-stash-puppet-communication-from-puppet-server = {
      description                  = "Allow puppet traffic to the puppet-server from elk-stash"
      ip_protocol                  = "tcp"
      from_port                    = 8140
      to_port                      = 8140
      security_group_id            = aws_security_group.main["elk-stash"].id
      cidr_ipv4                    = null
      referenced_security_group_id = aws_security_group.main["puppet-server"].id
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
