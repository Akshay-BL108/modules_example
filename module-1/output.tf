output "aws_vpc" {
  value = "${aws_vpc.vpc.cidr_block}"
}

output "subnet1" {
  value = "${element(aws_subnet.public_subnet.*.id, 1 )}"
}

output "subnet2" {
  value = "${element(aws_subnet.public_subnet.*.id, 2 )}"
}

output "ptivet_subnet1" {
  value = "${element(aws_subnet.public_subnet.*.id, 1 )}"
}
output "ptivet_subnet2" {
  value = "${element(aws_subnet.public_subnet.*.id, 2 )}"
}

output "privet_subnet_id" {
  value = "${aws_subnet.privet_subnet[*].id}"
}
output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}