data "tfe_outputs" "infra" {
  organization = var.tf_cloud_organization
  workspace = "${coalesce(var.aws_genai, "infra")}"
}

data "aws_instances" "my_worker_nodes" {
  depends_on = [aws_eks_node_group.private-node-group-1-tf]
  instance_tags = {
    "eks:cluster-name" = aws_eks_cluster.eks-tf.name
  }
  instance_state_names = ["running", "pending"]  
}

data "aws_instance" "ec2_subnets" {
  depends_on = [aws_eks_addon.cluster-addons]
  count    = var.skip_ha_az_node_group ? var.desired_size : var.desired_size + var.desired_size
  instance_id = data.aws_instances.my_worker_nodes.ids[count.index]
}
