
resource "aws_eip" "main" {
  vpc              = true
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
  base_cidr_block = cidrsubnet(local.app_cidr,2,index(local.azs,each.key))
  networks        = [
    {
      name     = "app-subnet"
      new_bits = 1
    },
  ]
}

resource "aws_subnet" "app-subnet" {
  for_each          = nonsensitive(toset(local.azs))
  vpc_id            = local.vpc_id
  cidr_block        = module.subnet_addrs[each.key].network_cidr_blocks["app-subnet"]
  availability_zone = each.key
  tags              = {
    Name = format("%s-app-server-%s",local.project_prefix,each.key)
  }
}

resource "aws_route_table" "main" {
  vpc_id =local.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
  tags = {
    Name = format("%s-app-server-rt-%s", local.project_prefix, local.build_suffix)
  }
}

resource "aws_route_table_association" "app-subnet-association" {
  for_each       = nonsensitive(toset(local.azs))
  subnet_id      = aws_subnet.app-subnet[each.key].id
  route_table_id = aws_route_table.main.id
}
