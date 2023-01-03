resource "aws_eip" "main" {
  vpc              = true
}

# Create NAT Gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.id
  subnet_id     = var.public_subnet_ids[0]

  tags = {
    resource_owner = var.resource_owner
    Name          = format("%s-ngw-%s", var.project_prefix, var.build_suffix)
  }
}

module subnet_addrs {
  for_each = toset(var.azs)
  source          = "hashicorp/subnets/cidr"
  version         = "1.0.0"
  base_cidr_block = cidrsubnet(var.app_cidr,2,index(var.azs,each.key))
  networks        = [
    {
      name     = "app-subnet"
      new_bits = 1
    },
  ]
}

resource "aws_subnet" "app-subnet" {
  for_each = toset(var.azs)
  vpc_id            = var.vpc_id
  cidr_block        = module.subnet_addrs[each.key].network_cidr_blocks["app-subnet"]
  availability_zone = each.key
  tags              = {
    Name = format("%s-eapp-server-%s",var.project_prefix,each.key)
  }
}

resource "aws_route_table" "main" {
  vpc_id =var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
  tags = {
    Name = format("%s-app-server-rt-%s", var.project_prefix, var.build_suffix)
  }
}

resource "aws_route_table_association" "app-subnet-association" {
  for_each       = toset(var.azs)
  subnet_id      = aws_subnet.app-subnet[each.key].id
  route_table_id = aws_route_table.main.id
}
