#Restrict Default VPC SG
resource "aws_default_security_group" "restrict_dsg" {
  vpc_id = module.vpc.vpc_id
  tags = {
    Name  = format("%s-default-sg-%s", var.project_prefix, random_id.build_suffix.hex)
    Owner = var.resource_owner
  }
}

#Security Group External
resource "aws_security_group" "external" {
  name   = format("%s-sg-ext-%s", var.project_prefix, random_id.build_suffix.hex)
  vpc_id = module.vpc.vpc_id

  tags = {
    Name  = format("%s-sg-ext-%s", var.project_prefix, random_id.build_suffix.hex)
    Owner = var.resource_owner
  }
}

#Security Group External - traffic rules
resource "aws_security_group_rule" "sg_ingress_public_443" {
  security_group_id = aws_security_group.external.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "sg_ingress_public_8443" {
  security_group_id = aws_security_group.external.id
  type              = "ingress"
  from_port         = 8443
  to_port           = 8443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "sg_ingress_public_80" {
  security_group_id = aws_security_group.external.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "sg_egress_public" {
  security_group_id = aws_security_group.external.id
  type              = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

#Security Group - MGMT
resource "aws_security_group" "management" {
  name   = format("%s-sg-mgmt-%s", var.project_prefix, random_id.build_suffix.hex)
  vpc_id = module.vpc.vpc_id

  tags = {
    Name  = format("%s-sg-mgmt-%s", var.project_prefix, random_id.build_suffix.hex)
    Owner = var.resource_owner
  }
}

#Security Group External - traffic rules
resource "aws_security_group_rule" "sg_ingress_management_443" {
  security_group_id = aws_security_group.management.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "sg_ingress_management_8443" {
  security_group_id = aws_security_group.management.id
  type              = "ingress"
  from_port         = 8443
  to_port           = 8443
  protocol          = "tcp"
  cidr_blocks = [var.admin_src_addr]
}
resource "aws_security_group_rule" "sg_ingress_management_22" {
  security_group_id = aws_security_group.management.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = [var.admin_src_addr]
}
resource "aws_security_group_rule" "sg_egress_management" {
  security_group_id = aws_security_group.management.id
  type              = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

#Security Group - Internal
resource "aws_security_group" "internal" {
  name   = format("%s-sg-int-%s", var.project_prefix, random_id.build_suffix.hex)
  vpc_id = module.vpc.vpc_id

  tags = {
    Name  = format("%s-sg-int-%s", var.project_prefix, random_id.build_suffix.hex)
    Owner = var.resource_owner

  }
}
#Security Group Internal - traffic rules
resource "aws_security_group_rule" "sg_ingress_internal" {
  security_group_id = aws_security_group.internal.id
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks = [module.vpc.vpc_cidr_block]
}
resource "aws_security_group_rule" "sg_ingress_internal_443" {
  security_group_id = aws_security_group.internal.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "sg_ingress_internal_80" {
  security_group_id = aws_security_group.internal.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "sg_egress_internal" {
  security_group_id = aws_security_group.internal.id
  type              = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}