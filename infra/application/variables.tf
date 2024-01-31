variable "instance_type" {
  default = "t2.micro"
  description = "Type of the instance"
  type        = string
}
variable "prefix" {
  default = "docker"
  type        = string
  description = "Name prefix"
}

variable "ports" {
    default = ["80","81","82"]
    type = list(string)
    description = "ports to be allowed ingress"
  
}