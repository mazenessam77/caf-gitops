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
  description = "Command to SSH into EKS node 1 via bastion"
  value       = "ssh -i ~/.ssh/caf-eks-key.pem -J ec2-user@${aws_instance.bastion.public_ip} ec2-user@10.0.10.130"
}

output "ssh_node2_via_bastion" {
  description = "Command to SSH into EKS node 2 via bastion"
  value       = "ssh -i ~/.ssh/caf-eks-key.pem -J ec2-user@${aws_instance.bastion.public_ip} ec2-user@10.0.11.137"
}
