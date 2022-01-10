
##################################################################################
# VARIABLES
##################################################################################

variable "name_prefix" {
  type        = string
  description = "Default Name for all resources"
  default     = "bk"
}

# variable "vpc_pub_cidr_block" {
#   type        = string
#   description = "Base CIDR Block for public subnet of VPC"
#   default     = "10.1.0.0/16"
# }

# variable "vpc_pri_cidr_block" {
#   type        = string
#   description = "Base CIDR Block for private subnet of  for VPC"
#   default     = "10.10.0.0/16"
# }

variable "vpc_db_cidr_block" {
  type        = string
  description = "Base CIDR Block for database subnet of  for VPC"
  default     = "10.20.0.0/16"
}

variable "user_name" {
  type = string
  sensitive = true
}

variable "pass_word" {
  type = string
  sensitive = true
}

variable "vpc_subnet_count" {
  type        = string
  description = "Number of subnets to create in VPC"
  default     = "2"
}

variable "aws_region" {
  type        = string
  description = "Region for AWS Resources"
  default     = "us-east-1"
}