variable "createzone" {
  description = "Whether to create Route53 zone"
  type        = bool
  default     = true
}

variable "zones" {
  description = "Map of Route53 zone parameters"
  type        = any
  default     = {}
}

variable "tags" {
  description = "Tags added to all zones. Will take precedence over tags from the 'zones' variable"
  type        = map(any)
  default     = {}
}

variable "createrecord" {
  description = "Whether to create DNS records"
  type        = bool
  default     = true
}

variable "zone_id" {
  description = "ID of DNS zone"
  type        = string
  default     = null
}

variable "zone_name" {
  description = "Name of DNS zone"
  type        = string
  default     = null
}

variable "private_zone" {
  description = "Whether Route53 zone is private or public"
  type        = bool
  default     = false
}

variable "records" {
  description = "List of objects of DNS records"
  type        = any
  default     = []
}

variable "records_jsonencoded" {
  description = "List of map of DNS records (stored as jsonencoded string, for terragrunt)"
  type        = string
  default     = null
}

variable "createds" {
  description = "Whether to create Route53 delegation sets"
  type        = bool
  default     = true
}

variable "delegation_sets" {
  description = "Map of Route53 delegation set parameters"
  type        = any
  default     = {}
}

variable "creaters" {
  description = "Whether to create Route53 Resolver rule associations"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "Default VPC ID for all the Route53 Resolver rule associations"
  type        = string
  default     = null
}

variable "resolver_rule_associations" {
  description = "Map of Route53 Resolver rule associations parameters"
  type        = any
  default     = {}
}

variable "full_name_override" {
  type        = bool
  default     = true
}

variable "app_env" {
}

variable "app_name" {
}

variable "app_id" {
}



