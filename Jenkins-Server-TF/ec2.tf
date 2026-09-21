resource "aws_instance" "jenkins"{
tags = {
Name = var.instance-name
}
ami           = data.aws_ami.ami.image_id
instance_type = var.instance-type
key_name      = var.key-name
subnet_id              = aws_subnet.public-subnet.id
vpc_security_group_ids = [aws_security_group.sg.id]
iam_instance_profile   = aws_iam_instance_profile.instance-profile.name
  root_block_device {
    volume_size = 20
  }
  user_data = templatefile("./tools-install.sh", {})
}

resource "aws_instance" "sonarqube_server" {
  ami                    = data.aws_ami.ami.image_id
  instance_type          = var.sonar-instance-type
  key_name               = var.key-name
  subnet_id              = aws_subnet.public-subnet.id
  vpc_security_group_ids = [aws_security_group.sg.id]

  root_block_device {
    volume_size = 20
  }

  user_data = file("./sonarqube.sh")

  tags = {
    Name = "SonarQube-Server"
  }
}

resource "aws_vpc" "myvpc"{
tags = {
Name = var.vpc-name
}
cidr_block = "10.0.0.0/16"
}
resource "aws_subnet" "public-subnet"{
vpc_id = aws_vpc.myvpc.id
availability_zone = "ap-south-1a"
cidr_block = "10.0.0.0/24"
map_public_ip_on_launch = true
tags = {
Name = var.subnet-name
}
}
resource "aws_route_table" "rt"{
tags = {
Name = var.rt-name
}
vpc_id = aws_vpc.myvpc.id
route {
cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.igw.id
}
}

resource "aws_route_table_association" "rt_association"{
route_table_id = aws_route_table.rt.id
subnet_id = aws_subnet.public-subnet.id
}
resource "aws_internet_gateway" "igw"{
tags = {
Name = var.igw-name
}
vpc_id = aws_vpc.myvpc.id
}

resource "aws_security_group" "sg"{
  tags = {
    Name = var.sg-name
  }
  vpc_id = aws_vpc.myvpc.id
    dynamic "ingress" {
     for_each = [22, 8080, 9000]
     content {
       from_port = ingress.value
       to_port = ingress.value
       protocol = "tcp"
       cidr_blocks = ["0.0.0.0/0"]
}
}
    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
