#+--------+ PROVIDER +--------+
 
provider "aws" {
    region = "us-east-1"
}
 
#+--------+ +--------+ +--------+ +--------++--------+ +--------+


  # VPC
resource "aws_vpc" "vpc_k8s" {
    cidr_block           = "10.0.0.0/24"
    enable_dns_hostnames = true
    enable_dns_support   = true
 
    tags = {
      Name       = "vpc_project_k8s"
      Managedby  = "Terraform"
      Owner      = "nicolas.pereira"
    }
}   
 
 
  # security is default
resource "aws_default_security_group" "sg_k8s" {
  vpc_id = aws_vpc.vpc_k8s.id

  
    ingress {
        protocol    = "tcp"
        self        = true
        from_port   = 22
        to_port     = 22
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
        tags = {
            Name       = "sg-project-k8s"
            Managedby  = "Terraform"
            Owner      = "nicolas.pereira"
        } 
}

resource "aws_internet_gateway" "igw_k8s" {
  vpc_id = aws_vpc.vpc_k8s.id


  tags = {
    Name       = "igw_k8s"
    Managedby  = "Terraform"
  }

}

    # route table
resource "aws_route_table" "route_table_k8s" {
  vpc_id       = aws_vpc.vpc_k8s.id
  
  tags = {
    Name       = "route_table_k8s"
    Managedby  = "Terraform"
  }
}

resource "aws_route" "routes_app" {
  route_table_id         = aws_route_table.route_table_k8s.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_k8s.id
}

resource "aws_route_table_association" "rtb_association_pub" {
  subnet_id       = aws_subnet.sub_public_sub_1a.id
  route_table_id  = aws_route_table.route_table_k8s.id
}

resource "aws_route_table_association" "rtb_association_private" {
  subnet_id       = aws_subnet.sub_private_2b.id
  route_table_id  = aws_route_table.route_table_k8s.id
}


  # SUBNET - public
resource "aws_subnet" "sub_public_sub_1a" {
  vpc_id            = aws_vpc.vpc_k8s.id
  cidr_block        = "10.0.0.0/25"
  availability_zone = "us-east-1a"
 
    tags = {
      "Name"     = "${local.aplication_sub_pub_1a}"
      Managedby  = "Terraform"
      Owner      = "nicolas.pereira"
    }
}     
 
  # SUBNET - private
resource "aws_subnet" "sub_private_2b" {
  vpc_id            = aws_vpc.vpc_k8s.id
  cidr_block        = "10.0.0.128/25"
  availability_zone = "us-east-1b"
    
    tags = {
      "Name"     = "${local.aplication_sub_priv_2b}"
      Managedby  = "Terraform"
      Owner      = "nicolas.pereira"
    }  
}
 

 
#+--------+ +--------+ +--------+ +--------++--------+ +--------+
 
 
  # EC2_INSTANCE_RANCHER_SERVER

resource "aws_instance" "rancher_server" {
    ami             = "ami-0149b2da6ceec4bb0"
    instance_type   = "t3.micro" 
    key_name        = "rancher-k8s"
    subnet_id       = aws_subnet.sub_public_sub_1a.id
 
    tags = {
       Name       = "Rancher_server"
       Managedby  = "Terraform"
       Owner      = "nicolas.pereira"       
    }

  # root disk
    root_block_device {
        volume_size           = "30"
        volume_type           = "gp2"
        encrypted             = true
        delete_on_termination = true

        tags = {
            Name	              = "vol_root_Rancher_server"
            Managedby             = "Terraform"
            Repository            = "GitHub"
            Owner	              = "nicolas.pereira"
        }        
    }
}
#+--------+ +--------+ +--------+ +--------++--------+ +--------+
 
  # EC2_INSTANCE_K8S-1
resource "aws_instance" "k8s_1" {
    ami             = "ami-0149b2da6ceec4bb0"
    instance_type   = "t3.micro" 
    key_name        = "rancher-k8s"
    subnet_id       = aws_subnet.sub_public_sub_1a.id
    
    tags = {
       "Name"     = "${local.aplication_name_instance}1"
       Managedby  = "Terraform"
       Owner      = "nicolas.pereira"   
    }

  # root disk
    root_block_device {
        volume_size           = "30"
        volume_type           = "gp2"
        encrypted             = true
        delete_on_termination = true

        tags = {
            "Name"	              = "${local.aplication_name_disk}1"
            Managedby             = "Terraform"
            Repository            = "GitHub"
            Owner	              = "nicolas.pereira"
        }        
    }
}
#+--------+ +--------+ +--------+ +--------++--------+ +--------+
 
  # EC2_INSTANCE_K8S-2
resource "aws_instance" "k8s_2" {
    ami             = "ami-0149b2da6ceec4bb0"
    instance_type   = "t3.micro" 
    key_name        = "rancher-k8s"
    subnet_id       = aws_subnet.sub_public_sub_1a.id
    
    tags = {
       "Name"     = "${local.aplication_name_instance}2"
       Managedby  = "Terraform"
       Owner      = "nicolas.pereira"   
    }

  # root disk
    root_block_device {
        volume_size           = "30"
        volume_type           = "gp2"
        encrypted             = true
        delete_on_termination = true

        tags = {
            "Name"	              = "${local.aplication_name_disk}2"
            Managedby             = "Terraform"
            Repository            = "GitHub"
            Owner	              = "nicolas.pereira"
        }        
    }
}
 
#+--------+ +--------+ +--------+ +--------++--------+ +--------+
 
  # EC2_INSTANCE_K8S-3
resource "aws_instance" "k8s_3" {
    ami             = "ami-0149b2da6ceec4bb0"
    instance_type   = "t3.micro" 
    key_name        = "rancher-k8s"
    subnet_id       = aws_subnet.sub_public_sub_1a.id
    
    tags = {
       "Name"     = "${local.aplication_name_instance}3"
       Managedby  = "Terraform"
       Owner      = "nicolas.pereira"   
    }

  # root disk
    root_block_device {
        volume_size           = "30"
        volume_type           = "gp2"
        encrypted             = true
        delete_on_termination = true

        tags = {
            "Name"	              = "${local.aplication_name_disk}3"
            Managedby             = "Terraform"
            Repository            = "GitHub"
            Owner	              = "nicolas.pereira"
        }        
    }
}