output "asgsc_application" {
  value       = "${aws_subnet.application.*.id}"
}

output "subnet_public" {
  value       = "${aws_subnet.public.*.id}"
}

output "application" {
  value       = "${aws_route_table.application.*.id}"
}
