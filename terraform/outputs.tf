output "instance_id" {
  description = "ID de l'instance EC2"
  value       = aws_instance.app.id
}

output "public_ip" {
  description = "Adresse IP publique (Elastic IP)"
  value       = aws_eip.app.public_ip
}

output "ssh_command" {
  description = "Commande pour se connecter en SSH"
  value       = "ssh -i ~/.ssh/${var.key_name}.pem ubuntu@${aws_eip.app.public_ip}"
}


# COMMENTAIRES


# c'est la manière dont tu exposes des informations clés après le déploiement. Une fois l'infrastructure créée, 
# Terraform te donnera l’ID de l’instance, son IP publique, et même la commande SSH prête à l’emploi pour te connecter. 
# En gros, c’est un petit guide post-déploiement pour accéder à ton serveur facilement.


# les outputs ne déploient rien en tant que tel. Ils servent juste à afficher des informations une fois que l’infrastructure est déployée. 
# En somme, ils sont là pour te donner des repères utiles sur les ressources créées, mais ils ne construisent pas directement ton infrastructure.