locals {
  ingress_rules = {
    kibana-ssh-from-internet = {
      description                  = "Allow SSH traffic to kibanal from internet"
      ip_protocol                  = "tcp"
      from_port                    = 22
      to_port                      = 22
      security_group_id            = aws_security_group.main["kibana"].id
      cidr_ipv4                    = "0.0.0.0/0"
      referenced_security_group_id = null
    }

    kibana-5601-from-internet = {
      description                  = "Allow SSH traffic to kibanal from internet"
      ip_protocol                  = "tcp"
      from_port                    = 5601
      to_port                      = 5601
      security_group_id            = aws_security_group.main["kibana"].id
      cidr_ipv4                    = "0.0.0.0/0"
      referenced_security_group_id = null
    }

    elasticsearch-ssh-from-kibana = {
      description                  = "Allow SSH traffic to elasticsearch from internet"
      ip_protocol                  = "tcp"
      from_port                    = 22
      to_port                      = 22
      security_group_id            = aws_security_group.main["elasticsearch"].id
      cidr_ipv4                    = null
      referenced_security_group_id = aws_security_group.main["kibana"].id
    }

    elasticsearch-9200-from-kibana = {
      description                  = "Allow SSH traffic to elasticsearch from internet"
      ip_protocol                  = "tcp"
      from_port                    = 9200
      to_port                      = 9200
      security_group_id            = aws_security_group.main["elasticsearch"].id
      cidr_ipv4                    = null
      referenced_security_group_id = aws_security_group.main["kibana"].id
    }

    elasticsearch-9200-from-logstash = {
      description                  = "Allow SSH traffic to elasticsearch from internet"
      ip_protocol                  = "tcp"
      from_port                    = 9200
      to_port                      = 9200
      security_group_id            = aws_security_group.main["elasticsearch"].id
      cidr_ipv4                    = null
      referenced_security_group_id = aws_security_group.main["logstash"].id
    }

    logstash-ssh-from-kibana = {
      description                  = "Allow SSH traffic to elasticsearch from internet"
      ip_protocol                  = "tcp"
      from_port                    = 22
      to_port                      = 22
      security_group_id            = aws_security_group.main["logstash"].id
      cidr_ipv4                    = null
      referenced_security_group_id = aws_security_group.main["kibana"].id
    }
  }
  egress_rules = {
    kibana-to-internet-http = {
      description                  = "Allow http traffic from kibana to the internet"
      ip_protocol                  = "tcp"
      from_port                    = 80
      to_port                      = 80
      security_group_id            = aws_security_group.main["kibana"].id
      cidr_ipv4                    = "0.0.0.0/0"
      referenced_security_group_id = null
    }
    kibana-to-internet-https = {
      description                  = "Allow https traffic from kibana to the internet"
      ip_protocol                  = "tcp"
      from_port                    = 443
      to_port                      = 443
      security_group_id            = aws_security_group.main["kibana"].id
      cidr_ipv4                    = "0.0.0.0/0"
      referenced_security_group_id = null
    }
    kibana-to-elasticsearch-ssh = {
      description                  = "Allow traffic from kibana to elasticsearch"
      ip_protocol                  = "tcp"
      from_port                    = 22
      to_port                      = 22
      security_group_id            = aws_security_group.main["kibana"].id
      cidr_ipv4                    = null
      referenced_security_group_id = aws_security_group.main["elasticsearch"].id
    }

    kibana-to-elasticsearch-9200 = {
      description                  = "Allow traffic from kibana to elasticsearch"
      ip_protocol                  = "tcp"
      from_port                    = 9200
      to_port                      = 9200
      security_group_id            = aws_security_group.main["kibana"].id
      cidr_ipv4                    = null
      referenced_security_group_id = aws_security_group.main["elasticsearch"].id
    }

    kibana-to-logstash-ssh = {
      description                  = "Allow traffic from kibana to elasticsearch"
      ip_protocol                  = "tcp"
      from_port                    = 22
      to_port                      = 22
      security_group_id            = aws_security_group.main["kibana"].id
      cidr_ipv4                    = null
      referenced_security_group_id = aws_security_group.main["logstash"].id
    }
    elasticsearch-to-internet-http = {
      description                  = "Allow http traffic from kibana to the internet"
      ip_protocol                  = "tcp"
      from_port                    = 80
      to_port                      = 80
      security_group_id            = aws_security_group.main["elasticsearch"].id
      cidr_ipv4                    = "0.0.0.0/0"
      referenced_security_group_id = null
    }
    elasticsearch-to-internet-https = {
      description                  = "Allow https traffic from kibana to the internet"
      ip_protocol                  = "tcp"
      from_port                    = 443
      to_port                      = 443
      security_group_id            = aws_security_group.main["elasticsearch"].id
      cidr_ipv4                    = "0.0.0.0/0"
      referenced_security_group_id = null
    }

    logstash-to-internet-http = {
      description                  = "Allow http traffic from kibana to the internet"
      ip_protocol                  = "tcp"
      from_port                    = 80
      to_port                      = 80
      security_group_id            = aws_security_group.main["logstash"].id
      cidr_ipv4                    = "0.0.0.0/0"
      referenced_security_group_id = null
    }
    logstash-to-internet-https = {
      description                  = "Allow https traffic from kibana to the internet"
      ip_protocol                  = "tcp"
      from_port                    = 443
      to_port                      = 443
      security_group_id            = aws_security_group.main["logstash"].id
      cidr_ipv4                    = "0.0.0.0/0"
      referenced_security_group_id = null
    }

    logstash-to-elasticsearch-9200 = {
      description                  = "Allow https traffic from kibana to the internet"
      ip_protocol                  = "tcp"
      from_port                    = 9200
      to_port                      = 9200
      security_group_id            = aws_security_group.main["logstash"].id
      cidr_ipv4                    = "0.0.0.0/0"
      referenced_security_group_id = null
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
