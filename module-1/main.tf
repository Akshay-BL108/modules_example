## provider for the module run
provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAVYYASOQZOHY3LD6R"
  secret_key = "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"
} 

data "aws_availability_zones" "available" {}

## terraform version for the module run


## VPC MAIN MODULE FOR AWS 
resource "aws_vpc" "vpc" {
  cidr_block           = var.VPC_cidr 
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_cidrs)
  cidr_block              = element(var.public_cidrs, count.index)
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
 ##element(var.aws_availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet"
  }
}

resource "aws_subnet" "privet_subnet" {
  count             = length(var.privet_cidrs)
  cidr_block        = element(var.privet_cidrs, count.index)
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
##element(var.aws_availability_zones, count.index)
  tags = {
    Name = "privet_subnet-${count.index + 1}"
  }
}

## internet gateway
resource "aws_internet_gateway" "Igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "IGW-VPC01"
  }
}


## ROUTING   
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0" ## PUBLIC 
    gateway_id = aws_internet_gateway.Igw.id
  }
  tags = {
    Name = "public_route"
  }
}

resource "aws_route_table" "privet_route" {
  vpc_id = aws_vpc.vpc.id

  route {

    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my-nat-gateway.id
  }
  tags = {
    Name = "privet_route"
  }
}

## Route Table  Association
resource "aws_route_table_association" "public_route_association" {
  count          = length(var.public_cidrs)
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
  route_table_id = aws_route_table.public_route.id
}


resource "aws_route_table_association" "privet_route_association" {
  count          = length(var.privet_cidrs)
  subnet_id      = element(aws_subnet.privet_subnet[*].id, count.index)
  route_table_id = aws_route_table.privet_route.id
}

## elastick ip
resource "aws_eip" "my-test-eip" {
  vpc = true
}

## nat getway for the privet subnet in PUBLIC SUBNET
resource "aws_nat_gateway" "my-nat-gateway" {

  allocation_id = aws_eip.my-test-eip.id
  subnet_id     = aws_subnet.public_subnet.0.id

  tags = {
    Name = "gw NAT"
  }
}

# Security Group Creation  
resource "aws_security_group" "test_sg" {
  name   = "my-test-sg"
  vpc_id = aws_vpc.vpc.id
}

# Ingress Security Port 22
resource "aws_security_group_rule" "ssh_inbound_access" {
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.test_sg.id
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "mysql_inbound_access" {
  from_port         = 3306
  protocol          = "tcp"
  security_group_id = aws_security_group.test_sg.id
  to_port           = 3306
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "http_inbound_access" {
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.test_sg.id
  to_port           = 80
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

# All OutBound Access
resource "aws_security_group_rule" "all_outbound_access" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.test_sg.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}


