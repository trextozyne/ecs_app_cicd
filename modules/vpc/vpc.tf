# Create the VPC
resource "aws_vpc" "Main" {      # Creating VPC here
  cidr_block = var.main_vpc_cidr # Defining the CIDR block use 10.0.0.0/24 for demo

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.env}-env"
  }
}
# Create Internet Gateway and attach it to VPC
resource "aws_internet_gateway" "IGW" { # Creating Internet Gateway
  vpc_id = aws_vpc.Main.id              # vpc_id will be generated after we create VPC
}
# Create a Public Subnets.
resource "aws_subnet" "public" { # Creating Public Subnets
  count = var.availability_zones_count
  map_public_ip_on_launch = true

  vpc_id            = aws_vpc.Main.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Network = "Public"
    "kubernetes.io/cluster/${var.project}" = "shared"
    "kubernetes.io/role/elb"      = 1
  }
}
# Create a Private Subnet                   # Creating Private Subnets
resource "aws_subnet" "private" {
  count = var.availability_zones_count

  vpc_id            = aws_vpc.Main.id
  // This ensures that each subnet has a unique CIDR block that doesn't overlap with any others in the VPC.
  // terraform function cidrsubnet takes 3 arguments
  cidr_block        = var.private_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name                                   = "${var.project}-private-sg"
    "kubernetes.io/cluster/${var.project}" = "shared"
    "kubernetes.io/role/internal-elb"      = 1
  }
}

# Route table for Public Subnet's
resource "aws_route_table" "PublicRT" { # Creating RT for Public Subnet
  count = var.availability_zones_count
  vpc_id = aws_vpc.Main.id
  route {
    cidr_block = "0.0.0.0/0" # Traffic from Public Subnet reaches Internet via Internet Gateway
    gateway_id = aws_internet_gateway.IGW.id
  }
}

# Route table for Private Subnet's
resource "aws_route_table" "PrivateRT" { # Creating RT for Private Subnet
  count = var.availability_zones_count
  vpc_id = aws_vpc.Main.id

  route {
    cidr_block     = "0.0.0.0/0" # Traffic from Private Subnet reaches Internet via NAT Gateway
    nat_gateway_id = aws_nat_gateway.NATgw[count.index].id #
  }

  tags = {
    Name = "${var.project}-private"
  }
}

locals {
#  number_of_public_subnet_per_az = floor(local.public_subnet_count / var.availability_zones_count)
#  number_of_private_subnet_per_az = floor(local.private_subnet_count / var.availability_zones_count)
  public_subnet_count  = 2
  private_subnet_count = 2
}

resource "aws_route_table_association" "public_RT_association" {
  count = local.public_subnet_count # i.e. 2 => [0,1]

  subnet_id         = aws_subnet.public[count.index].id
  route_table_id    = aws_route_table.PublicRT[count.index].id
}

resource "aws_route_table_association" "private_RT_association" {
  count =  local.private_subnet_count# i.e. 4 => [0,1,2,3] % => [0, 1, 0, 1]

  subnet_id         = aws_subnet.private[count.index].id
  route_table_id    = aws_route_table.PrivateRT[count.index].id
}

resource "aws_eip" "nateIP" {
  count = var.availability_zones_count
}

# Creating the NAT Gateway using subnet_id and allocation_id
resource "aws_nat_gateway" "NATgw" {
  count = var.availability_zones_count

  allocation_id = aws_eip.nateIP[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "nat"
  }
}

#resource "aws_nat_gateway" "NATgw2" {
#  allocation_id = aws_eip.nateIP.id
#  subnet_id     = aws_subnet.public[1].id
#}

## Region availablity
data "aws_availability_zones" "available" {
  state = "available"
}

# VPC module copied
