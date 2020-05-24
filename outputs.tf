#Output address of the instance
output "address" {
  value = "${aws_instance.ex-ec2-instance.private_ip}"
}
# Output elastic IP of the instance
output "elastic_ip" {
  value = "${aws_eip.elasticIP.public_ip}"
}
#Output IAM Access key
output "access_key" {
  value = "${aws_iam_access_key.ex-admin-access-key.id}"
}
#Output secret key
output "secret_key" {
  value = "${aws_iam_access_key.ex-admin-access-key.secret}"
}