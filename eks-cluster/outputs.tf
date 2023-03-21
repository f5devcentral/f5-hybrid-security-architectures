output "int_eks_subnet_az1" {
  description = "ID of Internal subnet AZ1"
  value       = values(aws_subnet.eks-internal)[0].id
}

output "private_eks_az1_cidr_block" {
value  =  values(aws_subnet.eks-internal)[0].cidr_block  
}

output "cluster_id" {
  description = "EKS cluster ID"
  value       = aws_eks_cluster.eks-tf.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.eks-tf.endpoint
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = nonsensitive(aws_eks_cluster.eks-tf.name)
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.eks-tf.certificate_authority[0].data
  sensitive = true
}

