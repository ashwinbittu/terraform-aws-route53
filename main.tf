locals {

  records = concat(var.records, try(jsondecode(var.records_jsonencoded), []))
  recordsets = { for rs in local.records : try(rs.key, join(" ", compact(["${rs.name} ${rs.type}", try(rs.set_identifier, "")]))) => rs }
}

resource "aws_route53_zone" "this" {
  for_each = { for k, v in var.zones : k => v if var.createzone }

  name          = lookup(each.value, "domain_name", each.key)
  comment       = lookup(each.value, "comment", null)
  force_destroy = lookup(each.value, "force_destroy", false)

  delegation_set_id = lookup(each.value, "delegation_set_id", null)

  dynamic "vpc" {
    for_each = try(tolist(lookup(each.value, "vpc", [])), [lookup(each.value, "vpc", {})])

    content {
      vpc_id     = vpc.value.vpc_id
      vpc_region = lookup(vpc.value, "vpc_region", null)
    }
  }

  tags = merge(
    lookup(each.value, "tags", {}),
    var.tags
  )
}


data "aws_route53_zone" "this" {
  #count = var.createzone && (var.zone_id != null || var.zone_name != null) ? 1 : 0
  count = 1

  zone_id      = var.zone_id
  name         = var.zone_name
  private_zone = var.private_zone
}

resource "aws_route53_record" "this" {
  for_each = { for k, v in local.recordsets : k => v if var.createrecord && (var.zone_id != null || var.zone_name != null) }

  zone_id = data.aws_route53_zone.this[0].zone_id

  name                             = each.value.name != "" ? (lookup(each.value, "full_name_override", false) ? each.value.name : "${each.value.name}.${data.aws_route53_zone.this[0].name}") : data.aws_route53_zone.this[0].name
  type                             = each.value.type
  ttl                              = lookup(each.value, "ttl", null)
  records                          = try(each.value.records, null)
  set_identifier                   = lookup(each.value, "set_identifier", null)
  health_check_id                  = lookup(each.value, "health_check_id", null)
  multivalue_answer_routing_policy = lookup(each.value, "multivalue_answer_routing_policy", null)
  allow_overwrite                  = lookup(each.value, "allow_overwrite", false)

  dynamic "alias" {
    for_each = length(keys(lookup(each.value, "alias", {}))) == 0 ? [] : [true]

    content {
      name                   = each.value.alias.name
      zone_id                = try(each.value.alias.zone_id, data.aws_route53_zone.this[0].zone_id)
      evaluate_target_health = lookup(each.value.alias, "evaluate_target_health", false)
    }
  }

  dynamic "failover_routing_policy" {
    for_each = length(keys(lookup(each.value, "failover_routing_policy", {}))) == 0 ? [] : [true]

    content {
      type = each.value.failover_routing_policy.type
    }
  }

  dynamic "latency_routing_policy" {
    for_each = length(keys(lookup(each.value, "latency_routing_policy", {}))) == 0 ? [] : [true]

    content {
      region = each.value.latency_routing_policy.region
    }
  }

  dynamic "weighted_routing_policy" {
    for_each = length(keys(lookup(each.value, "weighted_routing_policy", {}))) == 0 ? [] : [true]

    content {
      weight = each.value.weighted_routing_policy.weight
    }
  }

  dynamic "geolocation_routing_policy" {
    for_each = length(keys(lookup(each.value, "geolocation_routing_policy", {}))) == 0 ? [] : [true]

    content {
      continent   = lookup(each.value.geolocation_routing_policy, "continent", null)
      country     = lookup(each.value.geolocation_routing_policy, "country", null)
      subdivision = lookup(each.value.geolocation_routing_policy, "subdivision", null)
    }
  }
}


resource "aws_route53_delegation_set" "this" {
  for_each = var.createds ? var.delegation_sets : tomap({})

  reference_name = lookup(each.value, "reference_name", null)
}


resource "aws_route53_resolver_rule_association" "this" {
  for_each = { for k, v in var.resolver_rule_associations : k => v if var.creaters }

  name             = try(each.value.name, null)
  vpc_id           = try(each.value.vpc_id, var.vpc_id)
  resolver_rule_id = each.value.resolver_rule_id
}



