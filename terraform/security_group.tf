resource "aws_security_group" "web" {
  name        = "${var.project_name}-${var.environment}-web-sg"
  description = "Autorise HTTP, HTTPS et SSH restreint"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH depuis mon IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Tout le trafic sortant autorisé"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-web-sg"
  }
}


# COMMENTAIRES

# Ce security group agit comme un pare-feu pour tes instances. En entrée, il autorise le SSH, mais seulement depuis ton IP (via la variable), 
# ainsi que le trafic HTTP et HTTPS depuis n’importe où, ce qui est typique pour un serveur web. 
# En sortie, il autorise tout le trafic. En gros, ça sécurise et contrôle qui peut se connecter à tes ressources tout en permettant 
# aux services web de fonctionner


#NGINX
# Le security group agit comme un filtre autour de ton instance. Si tu déploies un serveur web avec Nginx, 
# c’est lui qui répondra aux requêtes HTTP ou HTTPS, et le security group autorise ces connexions à atteindre ton instance. 
# En gros, Nginx sert le contenu, mais c’est le security group qui décide qui a le droit de frapper à la porte.