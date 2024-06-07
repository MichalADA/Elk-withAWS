output "apache_server_public_ip" {
  description = "Public IP address of the Apache server"
  value       = aws_instance.apache_server.public_ip
}

output "elk_server_public_ip" {
  description = "Public IP address of the ELK server"
  value       = aws_instance.elk_server.public_ip
}
