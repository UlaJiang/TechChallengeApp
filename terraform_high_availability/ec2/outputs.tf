output "instance1_id" {
  value = "${element(aws_instance.techapp-instance.*.id, 1)}"
}

output "instance2_id" {
  value = "${element(aws_instance.techapp-instance.*.id, 2)}"
}

output "instance1_id" {
  value = "${element(aws_instance.techapp-instance.*.id, 1)}"
}