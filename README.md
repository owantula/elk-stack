# ELK STACK Deployment on AWS using Puppet and Terraform

This GitHub repository contains resources required for provisioning ELK STACK on AWS using Puppet and Terraform.

## Infrastructure

The infrastructure for this ELK deployment is set up on **AWS**, utilizing **Terraform** for provisioning. The Terraform code responsible for the infrastructure can be located in the 'terraform' directory.

**Terraform Cloud** serves as the backend for Terraform, chosen for its ability to utilize Dynamic Credentials, effective variables management, and seamless integration with GitHub.

### Terraform Files

+ **main.tf** contains the configuration for **AWS Provider** and **Terraform Backend**
+ **variables.tf** used to store configuration for variables
+ **aws_vpc.tf** contains necessary resources to provision our Network Layer(VPC) such as Subnets,Routes, Gateways etc.
+ **aws_ec2.tf** contains necessary resources to provision our Computing Resources(EC2) such as instances, security groups, and EIPs.
+ **aws_security_groups.tf** contains necessary resources to provision Ingress and Egress rules for traffic to flow

Terraform code should be self documenting but to be sure:

**Network:**

One VPC created, with 2 Subnets Public and Private. Public has access to Internet over Internet Gateway and instances there can be accessed from internet. Private has access to internet over Nat GW and can't be accessed over internet directly.
The only instance that is reachable from internet is the **Kibana** which serves as SSH jump host, and hosts the [Kibana](http://35.158.148.2:5601/app/home#/)

**Compute:**

We provision 3 instances. All of them have acess to internet over HTTP and HTTPS.

**Kibana:**
+ Deployed in Public Subnet
+ Accessible from internet on port TCP22 and TCP5601
+ Serves as SSH Jump Host
+ Has access to Elasticsearch over TCP9200
  
**Elastic:**
+ Deployed in Private Subnet
+ Accessible internaly from Kibana and Logstash on TCP9200
+ Accessible over SSH from Kibana
  
**Logstash:**
+ Deployed in Private Subnet
+ Accessible over SSH from Kibana
+ Has access to Elasticsearch over TCP9200

