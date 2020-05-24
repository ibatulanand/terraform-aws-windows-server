# terraform-aws-windows-server
Terraform configuration for deployment of Windows server ec2 instance and related infrastructure on AWS.

It is an all-in-one configuration to get started with any instance on AWS.

Configuration:
- EC2 Instance: 
    Region: Asia-Pacific (Tokyo) ap-northeast-1
    Instance Type: m5.2xlarge (8 vCPU, 32GB RAM, 10Gbps NIC)
    OS: Windows Server 2019 Base
    HDD1 (C Drive): EBS Volume - SSD 2TB
    HDD2 (D Drive): EBS Volume - Cold HDD 8TB
    Elastic IP

- VPC: default
  Security Group :
    Ingress: rdp, http/https, ex(port 9447)
    Egress: http/https, ex(port 9447)

- IAM:
    IAM User: admin for instance
    Permission: Instance power on/off only
