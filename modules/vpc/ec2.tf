data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  # Filtering the AMI based on name and other properties
  filter {
    name   = "image-id"
    values = ["ami-0c614dee691cbbf37"]
  }

  # Optional: You can define more filters here as needed
}

resource "tls_private_key" "ec2_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "example" {
  key_name   = "ec2_ssh_key"
  public_key = tls_private_key.ec2_ssh_key.public_key_openssh
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"  # Change this to your preferred instance type
  key_name      = aws_key_pair.example.key_name  # Ensure you have an SSH key pair

  tags = {
    Name = "MyEC2Instance"
  }

  # Optional: Adding security group, IAM role, etc.
}

output "instance_public_ip" {
  value = aws_instance.example.public_ip
}

output "private_key_pem" {
  value = tls_private_key.ec2_ssh_key.private_key_pem
  sensitive = true
}