terraform {
  required_version = "~> 0.12"
}

#Define provider as AWS with credentials
provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

#Create an ec2 instance
resource "aws_instance" "ex-ec2-instance" {
  ami               = var.ami
  instance_type     = var.instance_type
  availability_zone = var.availability_zone

  key_name        = var.key_name
  security_groups = [aws_security_group.ex-security-group.name]
  tags = {
    Name = "ex-instance"
  }
  root_block_device {
    volume_size           = 1863    #2TB = 1863GiB
    volume_type           = "gp2"   #ssd-type
    delete_on_termination = "false"
  }
}

#Create Cold HDD type EBS volume
resource "aws_ebs_volume" "ex-hdd" {
  availability_zone = var.availability_zone
  type              = "sc1" #cold-hdd-type
  size              = 7451  #8TB = 7451GiB
  tags = {
    Name = "ex-hdd"
  }
}

#Attach EBS Volume to instance
resource "aws_volume_attachment" "ex-volume" {
  device_name = "xvdf"
  instance_id = aws_instance.ex-ec2-instance.id
  volume_id   = aws_ebs_volume.ex-hdd.id
}

#Generate an elastic ip
resource "aws_eip" "elasticIP" {
  instance = aws_instance.ex-ec2-instance.id
  vpc      = true
}

#Create security group
resource "aws_security_group" "ex-security-group" {
  name = "ex-security-group"

  #Allow ingress traffic for RDP
  ingress {
    from_port        = 3389
    to_port          = 3389
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  #Allow ingress traffic for ex port
  ingress {
    from_port        = 9447
    to_port          = 9447
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
#Allow ingress traffic for http
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  #Allow ingress traffic for https
  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  #Allow egress traffic for http
  egress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  #Allow egress traffic for https
  egress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  #Allow egress traffic for ex Port
  egress {
    from_port        = 9447
    to_port          = 9447
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

#Create IAM User
resource "aws_iam_user" "ex-admin" {
  name = "ex-admin"
}

#Create IAM Policy Document
data "aws_iam_policy_document" "ex-admin-policy" {
  statement {
    actions = [
      "ec2:StartInstances",
      "ec2:StopInstances",
    ]
    resources = [
      "arn:aws:ec2:${var.region}:*:instance/${aws_instance.ex-ec2-instance.id}"
    ]
  }

  statement {
    actions = [
      "ec2:DescribeInstances"
    ]
    resources = [
      "*"
    ]
  }
}

#Create IAM Policy 
resource "aws_iam_policy" "ex-admin-policy" {
  name   = "ex-admin-policy"
  policy = data.aws_iam_policy_document.ex-admin-policy.json
}

#Generate IAM Access Key
resource "aws_iam_access_key" "ex-admin-access-key" {
  user = aws_iam_user.ex-admin.name
}