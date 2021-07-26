resource "panos_wildfire_analysis_security_profile" "this" {
  for_each = var.wildfire != "optional" ? { for file in var.wildfire : file.name => file } : tomap({})

  name         = each.key
  device_group = try(each.value.device_group, "shared")
  description  = try(each.value.description, null)

  dynamic "rule" {
    for_each = try(each.value.rule, null) != null ? { for rules in each.value.rule : rules.name => rules } : tomap({})
    content {
      name         = rule.value.name
      applications = try(rule.value.applications, ["any"])
      file_types   = try(rule.value.file_types, ["any"])
      direction    = try(rule.value.direction, "both")
      analysis     = try(rule.value.analysis, "public-cloud")
    }
  }
}