variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
   description = "Pass the list of security groups"
   type = list
   default = null
}

variable "tenant_name" {
  description = "Name of the tenant"
  type = string 
  default = "mayuresh"
}
