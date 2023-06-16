provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAVYYASOQZOHY3LD6R"
  secret_key = "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"
} 


module "vpc" {
  source          = "./module-1" 
  VPC_cidr       = "10.0.0.0/16"
  public_cidrs    = ["10.0.1.0/24", "10.0.2.0/24"]
  privet_cidrs   = ["10.0.3.0/24", "10.0.4.0/24"]
}

module "ec2" {
  source = "./module-2"
  public_cidrs    = ["10.0.1.0/24", "10.0.2.0/24"]
  privet_cidrs   = ["10.0.3.0/24", "10.0.4.0/24"]
  key_name = "shh-key"
  pub_instance_ami = "ami-0f8ca728008ff5af4"
  pub_instance_type = "t3.micro"
  prv_instance_ami = "ami-0f8ca728008ff5af4"
  prv_instance_type = "t3.micro"
}  

# module "load_balancer" {
#   source = "./module-3"
#   load_balancer_type = "application"
#   Environment = "production"
#   ### privet_subnet_id = module.vpc.vpc_id
#   vpc_id = module.vpc.privet_subnet_id
#   instance1_id = "${module.ec2.instance1_id}"
#   instance2_id = "${module.ec2.instance2_id}"
#   subnet1 = "${module.vpc.subnet1}"
#   subnet2 = "${module.vpc.subnet2}"
# }

output "aws_vpc_module" {
  value = module.vpc.aws_vpc
}
output "ptivet_subnet1_module" {
  value = module.vpc.ptivet_subnet1
}
output "ptivet_subnet2_module" {
  value = module.vpc.ptivet_subnet2
}
