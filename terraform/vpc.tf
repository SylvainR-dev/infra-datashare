# Le VPC : le réseau privé virtuel qui contiendra toutes nos ressources
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
  }
}

# Le subnet public : la sous-partie du réseau où résidera l'EC2, accessible depuis Internet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-${var.environment}-public-subnet"
  }
}

# L'Internet Gateway : la porte de sortie/entrée du VPC vers Internet
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-${var.environment}-igw"
  }
}

# La table de routage : dit au subnet public comment atteindre Internet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-public-rt"
  }
}

# L'association entre le subnet public et sa table de routage
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}


# COMMENTAIRES

# Le VPC, c’est ton espace isolé. Le subnet public est un sous-réseau dans lequel tes ressources peuvent avoir une IP publique. 
# L’Internet Gateway est la porte d’accès à Internet, et la table de routage permet aux ressources de ce subnet de sortir vers Internet. 
# Chaque ressource est nommée avec le projet et l’environnement, ce qui rend tout ça bien organisé et adaptable


# l’idée c’est que chaque bloc que tu définis dans ton code Terraform va se traduire par une ressource réelle dans AWS. 
# Quand tu appliques ta configuration, Terraform orchestre la création de ton VPC, de ton subnet, de ta passerelle Internet 
# et de ta table de routage. En gros, c’est comme un plan que Terraform exécute pour que tout soit construit, configuré, 
# et opérationnel directement dans le cloud.

