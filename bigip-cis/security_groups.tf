resource "aws_network_interface_sg_attachment" "eks_ng_sg" {
  security_group_id = data.tfe_outputs.eks.values.node_security_group_id
  network_interface_id = data.aws_instance.bigip.network_interface_id
}

resource "aws_security_group_rule" "eks_ingress_internal_443" {
  security_group_id = data.aws_eks_cluster.eks-sg.vpc_config.0.cluster_security_group_id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["10.0.0.0/16"]
}
resource "aws_security_group_rule" "eks_ingress_internal_80" {
  security_group_id = data.aws_eks_cluster.eks-sg.vpc_config.0.cluster_security_group_id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["10.0.0.0/16"]
}
resource "aws_security_group_rule" "eks_ingress_internal_8081" {
  security_group_id = data.aws_eks_cluster.eks-sg.vpc_config.0.cluster_security_group_id
  type              = "ingress"
  from_port         = 8081
  to_port           = 8081
  protocol          = "tcp"
  cidr_blocks = ["10.0.0.0/16"]
}