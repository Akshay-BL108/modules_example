#creating key pair
resource "aws_key_pair" "tera-key" {
  key_name   = var.key_name
  public_key = file("${path.module}/id_rsa.pub")
   
}
## instance 
resource "aws_instance" "web" {
  ami           = var.pub_instance_ami
  instance_type = var.pub_instance_type
  count = 1
  key_name      = aws_key_pair.tera-key.key_name
  vpc_security_group_ids = ["${aws_security_group.allow_tls.id}"]
  tags = {
    Name = "First-${count.index+1}"
  }
  user_data = file("${path.module}/script.sh")
  subnet_id = "${element(var.public_cidrs, count.index )}"   ## "${var.public_cidrs[count.index]}"
}


resource "aws_instance" "web1" {
  ami           = var.pub_instance_ami
  instance_type = var.pub_instance_type
  count = 2
  key_name      = aws_key_pair.tera-key.key_name
  vpc_security_group_ids = ["${aws_security_group.allow_tls.id}"]
  tags = {
    Name = "First-${count.index+1}"
  }
  user_data = file("${path.module}/script.sh")
  subnet_id = "${element(var.privet_cidrs, count.index )}"  ## "${var.private_cidrs[count.index]}"
}
# availability_zone = "${var.availability_zone}"

##  security_group
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"

  dynamic "ingress" {
    for_each = [22, 80, 443] 
    iterator = port
    content {
      description = "TLS from VPC"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
    egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }
}








