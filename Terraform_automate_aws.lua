provider "aws" {
    region = "ap-south-1"
    access_key = "*************"
    secret_key = "***************************"
}

# VPC Creation

resource "aws_vpc" "prod_vpc"{
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "production"
  }
}

# Internet Gateway creation

resource "aws_internet_gateway" "gw"{
  vpc_id = aws_vpc.prod_vpc.id
  
  tags = {
    Name = "production"
  }
}

#Custom Route table creation

resource "aws_route_table" "prod_route_table"{
  vpc_id = aws_vpc.prod_vpc.id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.gw.id
    }
    
    route {
      ipv6_cidr_block = "::/0"
      gateway_id = aws_internet_gateway.gw.id
    }


  tags = {
    Name = "production"
  }
}

#Subnet Creation 

resource "aws_subnet" "prod_subnet_1"{
    vpc_id = aws_vpc.prod_vpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "ap-south-1a"
    
    tags = {
        Name = "production_subnet"
    }
}

#subnet, route table association

resource "aws_route_table_association" "a"{
    subnet_id = aws_subnet.prod_subnet_1.id
    route_table_id = aws_route_table.prod_route_table.id
}

#Security Group to allow port 22,80,443

resource "aws_security_group" "allow_web"{
    name        = "allow_web"
    description = "Allow web inbond traffic"
    vpc_id      = aws_vpc.prod_vpc.id

    ingress {
            description     = "HTTPS"
            from_port       = 443
            to_port         = 443
            protocol        = "tcp"
            cidr_blocks     = ["0.0.0.0/0"]
        }
    

    ingress {
            description     = "HTTP"
            from_port       = 80
            to_port         = 80
            protocol        = "tcp"
            cidr_blocks     = ["0.0.0.0/0"]
        }


    ingress {
            description     = "SSH"
            from_port       = 22
            to_port         = 22
            protocol        = "tcp"
            cidr_blocks     = ["0.0.0.0/0"]
        }
    

    egress {
            from_port       = 0
            to_port         = 0
            protocol        = "-1" #any protocol
            cidr_blocks     = ["0.0.0.0/0"]
        }
    

    tags = {
        Name = "allow_web"
    }
}

# Network interface with an ip in subnet 

resource "aws_network_interface" "web_server_nic" {
    subnet_id       = aws_subnet.prod_subnet_1.id
    private_ips     = ["10.0.0.50"]
    security_groups = [aws_security_group.allow_web.id]
}

#Assign elastic ip

resource "aws_eip" "two"{
    vpc = true
    network_interface           = aws_network_interface.web_server_nic.id
    associate_with_private_ip   = "10.0.0.50"
    depends_on                  = [aws_internet_gateway.gw]
}

#create Ubuntu  server and install/enable ansible

resource "aws_instance" "ansible_server" {
  ami               = "ami-0c1a7f89451184c8b"
  instance_type     = "t2.micro"
  availability_zone = "ap-south-1a"
  key_name          = "Terraform"

  network_interface{
      device_index  = 0
      network_interface_id = aws_network_interface.web_server_nic.id
  }

  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install software-properties-common -y
                sudo apt install ansible -y
                sudo mkdir ansible_file
                cd ansible_file/
                echo -e "[targets]\nlocalhost  ansible_connection=local" > DEV_INV
                EOF
    tags = {
        Name = "Ansible_server"
    }
}