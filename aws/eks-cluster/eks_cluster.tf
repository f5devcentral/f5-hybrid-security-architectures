
# Create EKS cluster and node groups
resource "aws_eks_cluster" "eks-tf" {

 name = local.cluster_name
 role_arn = aws_iam_role.eks-iam-role.arn

 vpc_config {
  security_group_ids      = flatten([aws_security_group.eks_cluster.id, aws_security_group.eks_nodes.id])
  endpoint_private_access = true
  endpoint_public_access  = true
  #public_access_cidrs = [var.admin_src_addr]
  public_access_cidrs = ["0.0.0.0/0"]
  subnet_ids = concat([for e in aws_subnet.eks-external: e.id], [for i in aws_subnet.eks-internal: i.id])
  }

 depends_on = [
  aws_iam_role.eks-iam-role,
 ]
}

resource "aws_eks_node_group" "private-node-group-1-tf" {
  cluster_name  = aws_eks_cluster.eks-tf.name
  node_group_name = format("%s-private-ng-1-%s", local.project_prefix, local.build_suffix)
  node_role_arn  = aws_iam_role.workernodes.arn
  subnet_ids = var.skip_private_subnet_creation ? [for i in aws_subnet.eks-external: i.id] : [for i in aws_subnet.eks-internal: i.id]
  instance_types = ["t3.2xlarge"]
 
  scaling_config {
   desired_size = var.desired_size
   max_size   = var.max_size
   min_size   = var.min_size
  }

  tags = {
    Name = format("%s-private-ng-1-%s", local.project_prefix, local.build_suffix)
  }
 
  depends_on = [
   aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
   aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
   aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
 }

 resource "aws_eks_addon" "cluster-addons" {
  for_each = { for addon in var.eks_addons : addon.name => addon }
  cluster_name = aws_eks_cluster.eks-tf.id
  addon_name = each.value.name
  resolve_conflicts = "OVERWRITE"
 }

 resource "aws_eks_addon" "ebs_csi_driver-addon" {
  cluster_name             = aws_eks_cluster.eks-tf.name
  addon_name               = "aws-ebs-csi-driver"
  service_account_role_arn = aws_iam_role.ebs_csi_driver.arn
}

resource "aws_eks_node_group" "private-node-group-2-tf" {
  count = var.skip_ha_az_node_group ? 0 : 1
  cluster_name  = aws_eks_cluster.eks-tf.name
  node_group_name = format("%s-private-ng-2-%s", local.project_prefix, local.build_suffix)
  node_role_arn  = aws_iam_role.workernodes.arn
  subnet_ids = var.skip_private_subnet_creation ? [for i in aws_subnet.eks-external: i.id] : [for i in aws_subnet.eks-internal: i.id]
  ami_type       = "AL2_x86_64"
  instance_types = ["t3.xlarge"]
 
  scaling_config {
   desired_size = var.desired_size
   max_size   = var.max_size
   min_size   = var.min_size
  }

  tags = {
    Name = format("%s-private-ng-2-%s", local.project_prefix, local.build_suffix)
  }
 
  depends_on = [
   aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
   aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
   aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
 }
