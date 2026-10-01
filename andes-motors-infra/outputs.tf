output "instance_id" {
  description = "ID de la instancia EC2 creada"
  value       = aws_instance.andes_motors_ec2.id
}

output "public_ip" {
  description = "IP pública de la instancia EC2"
  value       = aws_instance.andes_motors_ec2.public_ip
}

output "public_dns" {
  description = "DNS público de la instancia EC2"
  value       = aws_instance.andes_motors_ec2.public_dns
}

output "ssh_connection_command" {
  description = "Comando para conectarte por SSH a la instancia"
  value       = "ssh -i ${var.key_name}.pem ec2-user@${aws_instance.andes_motors_ec2.public_ip}"
}
