variable "key_name" {
    type = string
}

variable "pub_instance_ami" {
  type = string
}
variable "pub_instance_type" {
  type = string     
}

variable "prv_instance_ami" {
  type = string
}
variable "prv_instance_type" {
  type = string     
}

variable "public_cidrs" {
  type = list(string)
}
variable "privet_cidrs" {
  type = list(string)
}

