# Input variable definitions

variable "env_table_read_capacity" {
  description = "Read capacity for environment table."
  type        = number
  default     = 5
}

variable "env_table_write_capacity" {
  description = "Write capacity for environment table."
  type        = number
  default     = 2
}

variable "replica_regions" {
  description = "AWS region names (eg 'us-east-1') to create Global Table replicas in."
  type        = list(string)
  default     = []
}

