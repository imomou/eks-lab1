variable "vpc_id" {
  type = string
}
variable "private_subnet_ids" {
  type = list(string)
}
variable "db_username" {
  type = string
}
variable "db_password" {
  type      = string
  sensitive = true
}
variable "db_name" {
  type = string
}
variable "db_security_group_ids" {
  description = "List of security group IDs for the DB instance"
  type        = list(string)
  default     = []
}