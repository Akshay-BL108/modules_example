

output "instance1_id" {
  value = "${element(aws_instance.web1.*.id, 1)}"
}
output "instance2_id" {
  value = "${element(aws_instance.web1.*.id, 2)}"
}

