# variable "aws_availability_zones" {
#   type = list(string) 
# }
variable "VPC_cidr"  {
  type = string
}
variable "public_cidrs" {
  type = list(string)
}
variable "privet_cidrs" {
  type = list(string)
}


