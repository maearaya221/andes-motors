variable "aws_region" {
  description = "Región de AWS donde se desplegará la infraestructura"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Tipo de instancia EC2 (usar t2.micro o t3.micro en AWS Academy)"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Nombre del key pair de AWS que se usará para acceder por SSH (debe existir previamente en tu cuenta/consola de AWS Academy)"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "Rango de IPs permitido para conectarse por SSH. Cambia esto por tu IP pública (ej: 190.XX.XX.XX/32) para mayor seguridad"
  type        = string
  default     = "0.0.0.0/0"
}

variable "instance_name" {
  description = "Nombre (Tag Name) de la instancia EC2"
  type        = string
  default     = "andes-motors-monitoreo"
}
