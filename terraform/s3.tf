# Récupère l'ID de ton compte AWS, utilisé pour garantir un nom de bucket unique
# (les noms de bucket S3 sont uniques dans le monde entier, pas juste dans ton compte)
data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "uploads" {
  bucket = "${var.project_name}-${var.environment}-uploads-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name = "${var.project_name}-${var.environment}-uploads"
  }
}

# Bloque tout accès public au bucket : aucun fichier n'est accessible
# directement via une URL publique, seul le backend (via ses credentials IAM)
# peut lire/écrire dedans, et génère des liens de téléchargement temporaires
resource "aws_s3_bucket_public_access_block" "uploads" {
  bucket = aws_s3_bucket.uploads.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Chiffrement par défaut des objets stockés (gratuit, activé par bonne pratique)
resource "aws_s3_bucket_server_side_encryption_configuration" "uploads" {
  bucket = aws_s3_bucket.uploads.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}