output "public_ip" {
    description = "Public IP address of our demo node"
  value = aws_instance.demo-node.public_ip
}
output "ssh_command" {
  description = "SSH command to connect to the newly deployed node"
  value       = "ssh ubuntu@${aws_instance.demo-node.public_ip}"
}
