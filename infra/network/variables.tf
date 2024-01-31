variable "prefix" {
  default     = "docker"
  type        = string
  description = "Name prefix"
}


variable "public_cidr" {
  default     = "10.20.0.0/24"
  type        = string
  description = "Public Subnet CIDR"
}


variable "vpc_cidr_block" {
  default     = "10.20.0.0/16"
  type        = string
  description = "VPC to host static web site"
}
