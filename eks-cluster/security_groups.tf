
#Custer SG
resource "aws_security_group" "eks_cluster" {
  name        = format("%s-eks-cluster-sg-%s", local.project_prefix, local.build_suffix)
  description = "Cluster communication with worker nodes"
  vpc_id      = local.vpc_id

  tags = {
    Name = format("%s-eks-cluster-sg-%s", local.project_prefix, local.build_suffix)
  }
}
#Cluster SG rules 
resource "aws_security_group_rule" "cluster_inbound" {
  description              = "Allow worker nodes to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 443
  type                     = "ingress"
}
resource "aws_security_group_rule" "cluster_outbound" {
  description              = "Allow cluster API Server to communicate with the worker nodes"
  from_port                = 1024
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 65535
  type                     = "egress"
}

#Nodes SG
resource "aws_security_group" "eks_nodes" {
  name        = format("%s-eks-node-sg-%s", local.project_prefix, local.build_suffix)
  description = "Security group for all nodes in the cluster"
  vpc_id      = local.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = format("%s-eks-node-sg-%s", local.project_prefix, local.build_suffix)
    "kubernetes.io/cluster/aws_eks_cluster.eks-tf.name" = "owned"
  }
}
#Nodes SG rules 
resource "aws_security_group_rule" "eks_nodes" {
  description              = "Allow nodes to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 65535
  type                     = "ingress"
}
resource "aws_security_group_rule" "eks_nodes_inbound" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.eks_cluster.id
  to_port                  = 65535
  type                     = "ingress"
}

