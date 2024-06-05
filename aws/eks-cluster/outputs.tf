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

output "node_security_group_id" {
  description = "EKS NG SG ID"
  value = aws_security_group.eks_nodes.id
}

output "my_worker_nodes" {
  description = "Nodes with Private IP addresses"
  value = { for i in range(length(data.aws_instances.my_worker_nodes.ids)) : data.aws_instances.my_worker_nodes.ids[i] => data.aws_instances.my_worker_nodes.private_ips[i] }
}

output "private_ips" {
  description = "Private IP Address of Instances in Node Group"
  value = [for i in range(length(data.aws_instances.my_worker_nodes.ids)) : data.aws_instances.my_worker_nodes.private_ips[i]]
}
output "subnets_of_ec2" {
 description = "Instance Node subnets in Node Group"
 value = [for i in range(length(data.aws_instances.my_worker_nodes.ids)) : data.aws_instance.ec2_subnets[i].subnet_id]
}

output "availability_zones_ec2" {
  description = "Availability zones of deployed instances in orderly format"
  value = [for i in range(length(data.aws_instances.my_worker_nodes.ids)) : data.aws_instance.ec2_subnets[i].availability_zone]
}
