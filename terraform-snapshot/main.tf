# -----------------------------
# Provider configuration
# -----------------------------
provider "aws" {
  region = "ap-south-1"   # Choose your region
}

# -----------------------------
# Create a key pair (optional)
# -----------------------------
resource "aws_key_pair" "mykey" {
  key_name   = "terraform-key"
  public_key = file("~/.ssh/id_thahi.pub")
}

# -----------------------------
# Security group for SSH
# -----------------------------
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -----------------------------
# Create EC2 instance
# -----------------------------
resource "aws_instance" "myec2" {
  ami                         = "ami-0e6329e222e662a52" # Amazon Linux 2 AMI (Region-specific)
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.mykey.key_name
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "TerraformEC2"
  }
}
