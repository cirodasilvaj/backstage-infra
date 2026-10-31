variable "vpc_id" {
  description = "VPC ID where the EKS cluster and RDS instance reside"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for the RDS DB subnet group"
  type        = list(string)
}

variable "vpc_cidr_block" {
  description = "CIDR block of the VPC to allow PostgreSQL access from EKS nodes/pods"
  type        = string
}

variable "cluster_security_group_id" {
  description = "EKS cluster security group ID"
  type        = string
}

variable "db_identifier" {
  description = "RDS instance identifier"
  type        = string
  default     = "backstage-postgres"
}

variable "instance_class" {
  description = "Cheapest AWS RDS PostgreSQL instance class"
  type        = string
  default     = "db.t4g.micro"
}

variable "db_name" {
  description = "Initial PostgreSQL database name for Backstage"
  type        = string
  default     = "backstage_plugin_catalog"
}

variable "db_username" {
  description = "Master username for RDS PostgreSQL"
  type        = string
  default     = "backstage"
}

variable "db_password" {
  description = "Master password for RDS PostgreSQL"
  type        = string
  default     = "BackstageRds2026!"
}
