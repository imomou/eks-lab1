variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "ap-southeast-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}
variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}
variable "private_subnet_cidrs" {
  description = "List of private subnet CIDRs"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}
variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b"]
}
variable "cluster_name" {
  description = "EKS Cluster name"
  type        = string
  default     = "test-cluster"
}
variable "db_username" {
  description = "RDS PostgreSQL username"
  type        = string
}
variable "db_password" {
  description = "RDS PostgreSQL password"
  type        = string
  sensitive   = true
}
variable "db_name" {
  description = "RDS PostgreSQL database name"
  type        = string
  default     = "mydatabase"
}