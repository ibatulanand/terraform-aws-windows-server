variable "access_key" {
  description = "Access key for AWS account - make sure to update it"
  default = "YOUR_AWS_ACCESS_KEY"
}
variable "secret_key" {
  description = "Secret key for AWS account - make sure to update it"
  default = "YOUR_AWS_SECRET_KEY"
}
variable "region" {
  default = "ap-northeast-1"
}
variable "availability_zone" {
  description = "availability zone for volume and instance"
  default     = "ap-northeast-1a"
}
variable "ami" {
  description = "AMI for windows server 2019 base in northeast-ap-1 region"
  default     = "ami-008755994dfc325f7"
}
variable "instance_type" {
  description = "type for AWS instance - NOT FOR FREE TIER"
  default     = "m5.2xlarge"
}
variable "key_name" {
  description = "key pair for accessing the AWS instance - already created"
  default     = "ex-key"
}

