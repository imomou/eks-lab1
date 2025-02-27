variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}
variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}
variable "private_subnet_cidrs" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}
variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}
variable "aws_region" {
  description = "AWS region"
  type        = string
}
