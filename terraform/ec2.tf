# Recherche automatique de la dernière AMI Ubuntu 24.04 LTS disponible dans la région
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "app" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name               = var.key_name

  tags = {
    Name = "${var.project_name}-${var.environment}-ec2"
  }
}

resource "aws_eip" "app" {
  instance = aws_instance.app.id
  domain   = "vpc"

  tags = {
    Name = "${var.project_name}-${var.environment}-eip"
  }
}


# COMMENTAIRES
# ce fichier décrit le déploiement de ton instance EC2. D’abord, tu cherches automatiquement la dernière image Ubuntu 24.04. 
# Ensuite, tu crées l’instance EC2 avec cette image, le type d’instance défini par ta variable, dans ton subnet public, 
# et avec ton security group. Enfin, tu attaches une IP élastique pour avoir une adresse publique fixe. 
# En somme, ce fichier assure que ton serveur soit prêt, avec la bonne image, le bon type, et une IP stable.


# bloc data
# le bloc "data" te permet de récupérer une ressource existante, ici l’AMI Ubuntu la plus récente. 
# Les filtres, eux, sont des critères de recherche. Par exemple, on filtre sur le nom de l’image pour s’assurer que c’est bien une Ubuntu 24.04, 
# et sur le type de virtualisation.


# resource "aws_instance"
définit vraiment ton instance EC2. Tu prends l’AMI trouvée (donc l’image Ubuntu) et tu précises le type d’instance (par exemple t3.small via ta variable), 
# le subnet (donc ton réseau), et le security group. En gros, c’est là que tu dis : « Voilà le serveur que je veux, 
# avec ces paramètres et dans cet environnement.


# aws_eip
# associe une adresse IP élastique à ton instance EC2. Une IP élastique est une adresse publique fixe qui reste stable, 
# même si l’instance redémarre. C’est donc cette ressource qui garantit que ton serveur a une adresse publique stable.