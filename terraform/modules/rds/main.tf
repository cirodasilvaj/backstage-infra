resource "aws_db_subnet_group" "backstage" {
  name        = "${var.db_identifier}-subnet-group"
  description = "Subnet group for Backstage RDS PostgreSQL"
  subnet_ids  = var.subnet_ids

  tags = {
    Name = "${var.db_identifier}-subnet-group"
  }
}

resource "aws_security_group" "rds" {
  name        = "${var.db_identifier}-rds-sg"
  description = "Allow PostgreSQL 5432 access from EKS cluster VPC and nodes"
  vpc_id      = var.vpc_id

  ingress {
    description     = "PostgreSQL from EKS cluster security group"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.cluster_security_group_id]
  }

  ingress {
    description = "PostgreSQL from VPC CIDR"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.db_identifier}-rds-sg"
  }
}

# Cheapest possible AWS RDS PostgreSQL configuration:
# - db.t4g.micro (burstable Graviton2 micro instance)
# - 20 GB gp2 storage (minimum allowed by RDS), no storage autoscaling
# - Single-AZ (multi_az = false), no paid backup retention, skip final snapshot
resource "aws_db_instance" "backstage" {
  identifier             = var.db_identifier
  engine                 = "postgres"
  engine_version         = "16"
  instance_class         = var.instance_class
  allocated_storage      = 20
  max_allocated_storage  = 0
  storage_type           = "gp2"
  storage_encrypted      = true
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.backstage.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  multi_az                = false
  publicly_accessible     = false
  backup_retention_period = 0
  skip_final_snapshot     = true
  deletion_protection     = false
  apply_immediately       = true

  tags = {
    Name = var.db_identifier
  }
}
