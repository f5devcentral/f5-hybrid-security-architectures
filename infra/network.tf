############################ VPC ############################

# Create VPC, subnets, route tables, and IGW
module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "~> 4.0"
  name                 = "${var.project_prefix}-vpc-${random_id.build_suffix.hex}"
  cidr                 = var.cidr
  azs                  = var.azs
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    resource_owner = var.resource_owner
    Name          = "${var.project_prefix}-vpc-${random_id.build_suffix.hex}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = module.vpc.vpc_id
  tags   = {
    Name = "${var.project_prefix}-igw-${random_id.build_suffix.hex}"
  }
}

module subnet_addrs {
  for_each = toset(var.azs)
  source          = "hashicorp/subnets/cidr"
  version         = "1.0.0"
  base_cidr_block = cidrsubnet(module.vpc.vpc_cidr_block,4,index(var.azs,each.key))
  /*
VPC CIDR = 10.0.0.0/16
AZ1 = 10.0.0.0/20
AZ2 = 10.0.16.0/20
*/
  networks        = [
    {
      name     = "management"
      new_bits = 8
      #10.0.0.0/28
      #10.0.16.0/28
    },
    {
      name     = "internal"
      new_bits = 6
      #10.0.0.64/26
      #10.0.16.64/26
    },
    {
      name     = "external"
      new_bits = 6
      #10.0.0.128/26
      #10.0.16.128/26
    },
    {
      name     = "app-cidr"
      new_bits = 4
      #10.0.1.0/24 EC2
      #10.0.17.0/24 EKS
    }
  ]
}

resource "aws_subnet" "internal" {
  for_each = toset(var.azs)
  vpc_id            = module.vpc.vpc_id
  cidr_block        = module.subnet_addrs[each.key].network_cidr_blocks["internal"]
  availability_zone = each.key
  tags              = {
    Name = format("%s-int-subnet-%s",var.project_prefix,each.key)
  }
}
resource "aws_subnet" "management" {
  for_each = toset(var.azs)
  vpc_id            = module.vpc.vpc_id
  cidr_block        = module.subnet_addrs[each.key].network_cidr_blocks["management"]
  availability_zone = each.key
  tags              = {
    Name = format("%s-mgmt-subnet-%s",var.project_prefix,each.key)
  }
}
resource "aws_subnet" "external" {
  for_each = toset(var.azs)
  vpc_id            = module.vpc.vpc_id
  cidr_block        = module.subnet_addrs[each.key].network_cidr_blocks["external"]
  map_public_ip_on_launch = true
  availability_zone = each.key
  tags              = {
    Name = format("%s-ext-subnet-%s",var.project_prefix,each.key)
  }
}
resource "aws_route_table" "main" {
  vpc_id = module.vpc.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.project_prefix}-rt-${random_id.build_suffix.hex}"
  }
}
resource "aws_route_table_association" "subnet-association-internal" {
  for_each       = toset(var.azs)
  subnet_id      = aws_subnet.internal[each.key].id
  route_table_id = aws_route_table.main.id
}
resource "aws_route_table_association" "subnet-association-management" {
  for_each       = toset(var.azs)
  subnet_id      = aws_subnet.management[each.key].id
  route_table_id = aws_route_table.main.id
}
resource "aws_route_table_association" "subnet-association-external" {
  for_each       = toset(var.azs)
  subnet_id      = aws_subnet.external[each.key].id
  route_table_id = aws_route_table.main.id
}
