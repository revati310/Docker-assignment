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
variable "repo_name" {
    type = list(string)
    default = ["app-repo","db-repo"]
    description = "repo names for app and db"
  
}
variable "image_mutability" {
  default = "IMMUTABLE"
  type = string
  description = "flag for image immutability"
}
variable "encryption_kind" {
    default = "KMS"
    type = string
    description = "kind of encryption"
}
