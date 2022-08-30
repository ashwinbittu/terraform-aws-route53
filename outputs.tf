
output "route53_zone_zone_id" {
  description = "Zone ID of Route53 zone"
  value       = { for k, v in aws_route53_zone.this : k => v.zone_id }
}

output "route53_zone_name_servers" {
  description = "Name servers of Route53 zone"
  value       = { for k, v in aws_route53_zone.this : k => v.name_servers }
}

output "route53_zone_name" {
  description = "Name of Route53 zone"
  value       = { for k, v in aws_route53_zone.this : k => v.name }
}

output "route53_record_name" {
  description = "The name of the record"
  value       = { for k, v in aws_route53_record.this : k => v.name }
}

output "route53_record_fqdn" {
  description = "FQDN built using the zone domain and name"
  value       = { for k, v in aws_route53_record.this : k => v.fqdn }
}

output "route53_delegation_set_id" {
  description = "ID of Route53 delegation set"
  value       = { for k, v in aws_route53_delegation_set.this : k => v.id }
}

output "route53_delegation_set_name_servers" {
  description = "Name servers in the Route53 delegation set"
  value       = { for k, v in aws_route53_delegation_set.this : k => v.name_servers }
}

output "route53_delegation_set_reference_name" {
  description = "Reference name used when the Route53 delegation set has been created"
  value       = { for k, v in aws_route53_delegation_set.this : k => v.reference_name }
}

output "route53_resolver_rule_association_id" {
  description = "ID of Route53 Resolver rule associations"
  value       = { for k, v in aws_route53_resolver_rule_association.this : k => v.id }
}

output "route53_resolver_rule_association_name" {
  description = "Name of Route53 Resolver rule associations"
  value       = { for k, v in aws_route53_resolver_rule_association.this : k => v.name }
}

output "route53_resolver_rule_association_resolver_rule_id" {
  description = "ID of Route53 Resolver rule associations resolver rule"
  value       = { for k, v in aws_route53_resolver_rule_association.this : k => v.resolver_rule_id }
}

