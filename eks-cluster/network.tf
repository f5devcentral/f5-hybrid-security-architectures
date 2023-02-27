

# Create Elastic IP
resource "aws_eip" "main" {
  vpc              = true
  tags = {
    resource_owner = local.resource_owner
    Name          = format("%s-eip-%s", local.project_prefix, local.build_suffix)
  }
}

# Create NAT Gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.id
  subnet_id     = local.public_subnet_ids[0]

  tags = {
    resource_owner = local.resource_owner
    Name          = format("%s-ngw-%s", local.project_prefix, local.build_suffix)
  }
}

module subnet_addrs {
  for_each        = nonsensitive(toset(local.azs))
  source          = "hashicorp/subnets/cidr"
  version         = "1.0.0"
  base_cidr_block = cidrsubnet(local.eks_cidr,2,index(local.azs,each.key))
  networks        = [
    {
      name     = "eks-internal"
      new_bits = 1
    },
    {
      name     = "eks-external"
      new_bits = 1
    }
  ]
}

resource "aws_subnet" "eks-internal" {
  for_each          = nonsensitive(toset(local.azs))
  vpc_id            = local.vpc_id
  cidr_block        = module.subnet_addrs[each.key].network_cidr_blocks["eks-internal"]
  availability_zone = each.key
  tags              = {
    Name = format("%s-eks-int-subnet-%s",local.project_prefix,each.key)
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"                      = "1"
  }
}
resource "aws_subnet" "eks-external" {
  for_each          = nonsensitive(toset(local.azs))
  vpc_id            = local.vpc_id
  cidr_block        = module.subnet_addrs[each.key].network_cidr_blocks["eks-external"]
  map_public_ip_on_launch = true
  availability_zone = each.key
  tags              = {
    Name = format("%s-eks-ext-subnet-%s",local.project_prefix,each.key)
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }
}
resource "aws_route_table" "main" {
  vpc_id = local.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
  tags = {
    Name = format("%s-eks-rt-%s", local.project_prefix, local.build_suffix)
  }
}
resource "aws_route_table_association" "internal-subnet-association" {
  for_each       = nonsensitive(toset(local.azs))
  subnet_id      = aws_subnet.eks-internal[each.key].id
  route_table_id = aws_route_table.main.id
}
resource "aws_route_table_association" "external-subnet-association" {
  for_each       = nonsensitive(toset(local.azs))
  subnet_id      = aws_subnet.eks-external[each.key].id
  route_table_id = local.vpc_main_route_table_id
}



