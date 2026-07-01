# Security group dédié à RDS : n'autorise le trafic PostgreSQL
# que depuis les instances utilisant le security group "web" (notre EC2)
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-${var.environment}-rds-sg"
  description = "Allow PostgreSQL only from web EC2"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "PostgreSQL from web EC2"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  egress {
    description = "All outbound traffic allowed"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-rds-sg"
  }
}