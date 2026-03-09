output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.main.name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = aws_eks_cluster.main.endpoint
}

output "ecr_repository_url" {
  description = "ECR repository URL for the CAF app"
  value       = aws_ecr_repository.caf_app.repository_url
}

output "eks_cluster_certificate_authority" {
  description = "EKS cluster CA certificate (base64)"
  value       = aws_eks_cluster.main.certificate_authority[0].data
  sensitive   = true
}

output "configure_kubectl" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --name ${aws_eks_cluster.main.name} --region ${var.aws_region}"
}

output "bastion_public_ip" {
  description = "Bastion host public IP for SSH access"
  value       = aws_instance.bastion.public_ip
}

output "ssh_bastion_command" {
  description = "Command to SSH into bastion host"
  value       = "ssh -i ~/.ssh/caf-eks-key.pem ec2-user@${aws_instance.bastion.public_ip}"
}

output "ssh_node1_via_bastion" {
  description = "Command to SSH into EKS node 1 via bastion (run: terraform output -raw ssh_node1_via_bastion)"
  value       = "ssh -o IdentitiesOnly=yes -i ~/.ssh/caf-eks-key.pem -J ec2-user@${aws_instance.bastion.public_ip} ec2-user@$(aws ec2 describe-instances --region ${var.aws_region} --filters 'Name=tag:eks:cluster-name,Values=${aws_eks_cluster.main.name}' 'Name=instance-state-name,Values=running' --query 'Reservations[0].Instances[0].PrivateIpAddress' --output text)"
}

output "ssh_node2_via_bastion" {
  description = "Command to SSH into EKS node 2 via bastion (run: terraform output -raw ssh_node2_via_bastion)"
  value       = "ssh -o IdentitiesOnly=yes -i ~/.ssh/caf-eks-key.pem -J ec2-user@${aws_instance.bastion.public_ip} ec2-user@$(aws ec2 describe-instances --region ${var.aws_region} --filters 'Name=tag:eks:cluster-name,Values=${aws_eks_cluster.main.name}' 'Name=instance-state-name,Values=running' --query 'Reservations[1].Instances[0].PrivateIpAddress' --output text)"
}

output "eks_node_ips" {
  description = "Current private IPs of EKS worker nodes"
  value = formatlist(
    "ssh -o IdentitiesOnly=yes -i ~/.ssh/caf-eks-key.pem -J ec2-user@%s ec2-user@NODE_IP",
    [aws_instance.bastion.public_ip]
  )
}
