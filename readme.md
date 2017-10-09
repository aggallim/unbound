#Unbound Deployment into AWS using Terraform

This is a terraform project to set up DNS resolution between your on-premises DNS with Amazon VPC by using Unbound, an open-source, recursive DNS resolver. This solution provides the ability to route DNS requests between on-premises environments and an Amazon VPC–provided DNS.

The solution is documented on the following AWS Blog.
https://aws.amazon.com/blogs/security/how-to-set-up-dns-resolution-between-on-premises-networks-and-aws-by-using-unbound/


#Pre-requisits
- Terraform 0.9.x (may work ok with 0.10.x)
- Default VPC
- AWS Access and Security keys


#Setup

1. Clone the master branch
2. terraform init
3. terraform plan
4. terraform apply
