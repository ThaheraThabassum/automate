provider "aws"{
    region = "ap-south-1"
}

#resource "aws_key_pair" "my_key"{
#    key_name = "terraform-key"
#    public_key = file("~/.ssh/id_thahi.pub")
#}

resource "aws_vpc" "my_vpc"{
    cidr_block = "10.0.0.0/16"
    tags={
        Name = "my_vpc"
    }
}
resource "aws_subnet" "public_subnet"{
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone = "ap-south-1a"
    tags = {
        Name="public-subnet"
    }
}
resource "aws_internet_gateway" "igw"{
    vpc_id = aws_vpc.my_vpc.id
    tags={
        Name="public-igw"
    }
}
resource "aws_route_table" "public_rt"{
    vpc_id = aws_vpc.my_vpc.id
    route  {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags={
        Name="public-rt"
    }
}
resource "aws_route_table_association" "public_rt_assoc"{
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_rt.id 
}
resource "aws_security_group" "my_sg"{
    vpc_id=aws_vpc.my_vpc.id
    ingress{
        from_port=22
        to_port=22
        protocol="tcp"
        cidr_blocks=["0.0.0.0/0"]
    }
    egress{
        from_port=0
        to_port=0
        protocol="-1"
        cidr_blocks=["0.0.0.0/0"]
    }
    tags={
        Name="mysg"
    }
}
resource "aws_instance" "public-ec2"{
    ami = "ami-00ca570c1b6d79f36"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_subnet.id
    availability_zone="ap-south-1a"
    key_name="terraform-key2"
    security_groups = [aws_security_group.my_sg.id]
    tags={
        Name="public-ec2"
    }
}
#---------------private subnet and instance creation------
resource "aws_key_pair" "private_ec2_key"{
    key_name="terraform-key2"
    public_key=file("~/.ssh/id_thahi.pub")
}
#resource "aws_vpc" "my_vpc"{
#    cidr_block="10.0.0.0/16"
#    tags={
#        Name="my_vpc"
#    }
#}
resource "aws_subnet" "private_subnet"{
    vpc_id=aws_vpc.my_vpc.id
    cidr_block="10.0.2.0/24"
    availability_zone="ap-south-1a"
}
#resource "aws_eip" "nat_eip"{
#    vpc=true
#}
#resource "aws_nat_gateway" "nat_gw"{
#    allocation_id=aws_eip.nat_eip.id
#    subnet_id=aws_subnet.private_subnet.id
#    tags={
#        Name="nat_gw"
#    }
#}
#resource "aws_route_table" "private_rt"{
#    vpc_id=aws_vpc.my_vpc.id
#    route{
#        cidr_block="0.0.0.0/0"
#        nat_gateway_id=aws_nat_gateway.nat_gw.id
#    }
#    tags={
#        Name="private_rt"
#    }
#}
#resource "aws_route_table_association" "private_rt_assoc"{
#    subnet_id=aws_subnet.private_subnet.id
#    route_table_id=aws_route_table.private_rt.id
#}
resource "aws_instance" "private-ec2"{
    ami="ami-00ca570c1b6d79f36"
    instance_type="t2.micro"
    subnet_id=aws_subnet.private_subnet.id
    key_name="terraform-key2"
    security_groups=[aws_security_group.my_sg.id]
    tags={
        Name="private-ec2"
    }
}