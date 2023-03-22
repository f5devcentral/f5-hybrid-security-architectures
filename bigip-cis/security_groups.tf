resource "aws_network_interface_sg_attachment" "eks_ng_sg" {
  security_group_id = data.tfe_outputs.eks.values.node_security_group_id
  network_interface_id = data.aws_instance.bigip.network_interface_id
}