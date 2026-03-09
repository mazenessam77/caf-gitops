# --------------------------------------------------------------------------
# Security Group for Bastion Host
# --------------------------------------------------------------------------
resource "aws_security_group" "bastion" {
  name        = "${var.project_name}-bastion-sg"
  description = "Security group for bastion host - SSH access"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-bastion-sg"
  }
}

# --------------------------------------------------------------------------
# Bastion Host EC2 Instance (in Public Subnet)
# --------------------------------------------------------------------------
resource "aws_instance" "bastion" {
  ami                         = "ami-05024c2628f651b80"   # Amazon Linux 2 us-east-1
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public[0].id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  key_name                    = "caf-eks-key"
  associate_public_ip_address = true

  tags = {
    Name = "${var.project_name}-bastion"
  }
}

# --------------------------------------------------------------------------
# Security Group Rule: Allow SSH from Bastion to EKS Nodes
# --------------------------------------------------------------------------
resource "aws_security_group_rule" "eks_nodes_from_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion.id
  security_group_id        = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
  description              = "Allow SSH from bastion to EKS nodes"
}
