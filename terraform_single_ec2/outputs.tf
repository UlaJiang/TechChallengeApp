output "ec2-public-ip" {
  value = aws_instance.techapp-instance.public_ip
}