variable "ami_id" {
  description = "ID de la AMI para la instancia EC2"
  default     = "ami-058bd2d568351da34"
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  default     = "t2.micro"
}

variable "key_name" {
  description = "Nombre de la clave SSH"
  default     = "legion33"
}

variable "security_groups" {
  description = "Lista de grupos de seguridad"
  type        = list(string)
  default     = ["sg-00ef3880ebb0de4a3"]
}

variable "subnet_id" {
  description = "ID de la subred"
  default     = "subnet-006c3fe4de694a734"
}

