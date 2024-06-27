variable "ami_id" {
  description = "ID de la AMI para la instancia EC2"
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
}

variable "key_name" {
  description = "Nombre de la clave SSH"
}

variable "security_groups" {
  description = "Lista de grupos de seguridad"
  type        = list(string)
}

variable "subnet_id" {
  description = "ID de la subred"
}

