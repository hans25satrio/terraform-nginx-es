variable "aws_access_key" {
  default = "{Dummy}AKIARYVWZUHH5SVPASF5F"
}

variable "aws_secret_key" {
  default = "{Dummy}Uh6C1jeZM8Qyw0HcF8qnaeSfkPK0mZ5SMiX4bmWV"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "ips" {
  default = {
    "1" = "172.28.0.6" #ES
    "2" = "172.28.0.5" #Nginx
  }
}

variable "vpcs" {
  default     = "172.28.0.0/16"
  description = "vpc hans"
}

variable "Subnet-Publics" {
  default     = "172.28.0.0/24"
  description = "subnet hans"
}

variable "key_name" {
  default = "hans-key"
}