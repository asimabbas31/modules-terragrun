 
output "vpcid" {
  value       = "${aws_vpc.payment.id}"
}

output "cidr_block" {
  value       = "${aws_vpc.payment.cidr_block}"
}
