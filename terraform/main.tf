// Add Provider
provider "aws" {
  region  = var.region
  profile = "default"
}

// Create a new VPC
resource "aws_vpc" "demo-vpc" {
  cidr_block = var.vpc_cidr_block
    
  tags = {
    Name = "demo-vpc"
  } 
}

// Create a new subnet
resource "aws_subnet" "demo-subnet" {
  vpc_id     = aws_vpc.demo-vpc.id
  cidr_block = var.subnet_cidr_block

  tags = {
    Name = "demo-subnet"
  } 
}

// Create a new internet gateway
resource "aws_internet_gateway" "demo-igw" {
  vpc_id = aws_vpc.demo-vpc.id

  tags = {
    Name = "demo-internet_gateway"
  } 
}

// Create a new route table
resource "aws_route_table" "demo-rt" {
  vpc_id = aws_vpc.demo-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-igw.id 
  }

  tags = {
    Name = "demo-route_table"
  }
}

// Associate the route table with the subnet
resource "aws_route_table_association" "demo-rt-assoc" {
  subnet_id      = aws_subnet.demo-subnet.id
  route_table_id = aws_route_table.demo-rt.id
}

// Create a new security group
resource "aws_security_group" "demo-sg" {
  name   = "demo-sg"
  vpc_id = aws_vpc.demo-vpc.id

  # Ingress rules for TCP ports
  dynamic "ingress" {
    for_each = [22, 80, 443, 3100]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # Ingress rules for UDP ports
  dynamic "ingress" {
    for_each = [22, 80, 443, 3100]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # Egress rule allowing all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "demo-security_group"
  }
}
# adding public key to instances authorized_keys file for ssh access/ansible
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("~/.ssh/id_rsa.pub")  
}

# Deploying demo node 
resource "aws_instance" "demo-node" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.demo-subnet.id
  security_groups        = [aws_security_group.demo-sg.id]
  key_name               = aws_key_pair.deployer.key_name 
  associate_public_ip_address = true

  # root_block_device {
  #   volume_size = 30  # Set this value to your desired size in GB
  #   volume_type = "gp3"  # Can be gp2, gp3, io1, or standard
  # }

  # User data script to install Ansible on Ubuntu
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y ansible
              EOF

  tags = {
    Name = "demo-node"
  }
}
