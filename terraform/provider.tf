terraform {
  required_version = ">= 1.7.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}



# COMMENTAIRES

# Le fichier provider.tf est la configuration qui définit quel fournisseur cloud Terraform utilisera. 
# Ici, tu spécifies AWS comme fournisseur, une version de Terraform minimale (1.7.0), et une version du provider AWS (autour de 5.x). 
# Enfin, tu précises la région AWS via une variable, permettant d’adapter ton infra selon l’environnement.

# la base nécessaire. Mais on peut enrichir progressivement. Par exemple, on peut définir des credentials plus sécurisés, 
# des tags par défaut, ou des configurations spécifiques selon l’environnement.