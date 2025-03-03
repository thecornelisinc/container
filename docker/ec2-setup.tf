
resource "aws_instance" "ec2_instances" {
  count         = 3
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.medium"
  key_name      = "docker-key"  # Replace with your key pair
  subnet_id     = "subnet-093620d66aca58b1e"  # Replace with your subnet ID
  vpc_security_group_ids = [aws_security_group.ec2_sg.id] # Attach security group
  associate_public_ip_address = true
  iam_instance_profile = "Adminaccecss"
  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y docker.io
              systemctl start docker
              systemctl enable docker
              EOF

  tags = {
    Name = "Docker-EC2-${count.index + 1}"
  }
}

# Fetch the latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's AWS account ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# Security Group for EC2 Instances
resource "aws_security_group" "ec2_sg" {
  vpc_id = "vpc-01544527be35afe04"
  name        = "ec2_security_group"
  description = "Allow SSH and Docker access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere (modify for security)
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere (modify for security)
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere (modify for security)
  }

  ingress {
    from_port   = 2375
    to_port     = 2376
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow Docker remote access
  }

#   ingress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"] # Allow Docker remote access
#   }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
