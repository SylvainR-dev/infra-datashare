variable "aws_region" {
  description = "Région AWS où déployer l'infrastructure"
  type        = string
  default     = "eu-west-3"
}

variable "project_name" {
  description = "Nom du projet, utilisé comme préfixe pour nommer les ressources"
  type        = string
  default     = "datashare"
}

variable "environment" {
  description = "Nom de l'environnement (sandbox, staging, prod...)"
  type        = string
  default     = "sandbox"
}

variable "vpc_cidr" {
  description = "Plage d'adresses IP du VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Plage d'adresses IP du subnet public"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "Type d'instance EC2"
  type        = string
  default     = "t3.small"
}

variable "key_name" {
  description = "Nom de la paire de clés SSH déjà créée dans AWS (EC2 > Key Pairs)"
  type        = string
}

variable "ssh_allowed_cidr" {
  description = "Plage IP autorisée à se connecter en SSH (ton IP publique en /32, idéalement)"
  type        = string
}



# COMMENTAIRES

# ce fichier sert à rendre ton infrastructure Terraform flexible. Il définit toutes les variables dont tu auras besoin pour adapter ton déploiement. 
# En gros, tu as des paramètres comme la région, le nom du projet, l’environnement, ou encore des détails réseau et machines. 
# Ces variables te permettent de réutiliser la même configuration sur différents environnements ou projets sans tout réécrire. 
# En gros, c’est ta boîte à outils de personnalisation
# Si un nouveau besoin apparaît, tu rajoutes une variable, et ensuite tu l’utilises dans tes ressources. 
# Ça te permet de faire évoluer ton infra sans tout réécrire.



# FONCTIONNEMENT
#c’est Terraform qui fait tout. Quand tu exécutes des commandes comme "terraform apply", Terraform lit ces fichiers, 
# il compare l’état actuel de ton infrastructure avec ce que tu as défini, et il interagit ensuite avec les API du cloud (comme AWS) pour créer, 
# modifier ou supprimer les ressources. En gros, c’est Terraform qui orchestre et pilote tout en dialoguant avec ton cloud provider.

# VARIABLE environnement
# elle te permet de différencier les contextes dans lesquels tu déploies. Par exemple, sandbox, c’est pour des tests, staging, 
# c’est une préproduction, et prod, c’est la production. En fonction de cette valeur, tu peux nommer tes ressources différemment ou 
# appliquer des configurations particulières. En somme, ça t’aide à gérer plusieurs environnements avec la même base, 
# tout en gardant une séparation claire


# VPC CIDR
# la plage d’adresses IP de ton réseau privé dans le cloud, ton VPC. C’est une sorte de grand bloc d’adresses IP que tu vas découper 
# ensuite en sous-réseaux plus petits. En gros, c’est la base de ton réseau virtuel sur AWS, et c’est essentiel pour organiser 
# toutes tes ressources de façon isolée et contrôlée.


# public_subnet
# c’est une sous-plage d’adresses IP à l’intérieur de ton VPC. Le VPC, c’est le réseau global, et le subnet, 
# c’est un petit morceau de ce réseau. Le public subnet, lui, est conçu pour des ressources qui doivent être accessibles depuis Internet, 
# comme des serveurs web. Donc en gros, c’est une partie de ton réseau où les ressources sont exposées au monde extérieur.