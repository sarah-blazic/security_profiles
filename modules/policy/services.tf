resource "panos_panorama_service_object" "this" {
  #for yaml files change jsondecode => yamldecode
  for_each = var.services_file != "optional" ? { for obj in jsondecode(file(var.services_file)) : obj.name => obj } : tomap({})

  destination_port             = each.value.destination_port
  name                         = each.key
  protocol                     = each.value.protocol
  device_group                 = try(each.value.device_group, "shared")
  description                  = try(each.value.description, null)
  source_port                  = try(each.value.source_port, null)
  tags                         = try(each.value.tags, null)
  override_session_timeout     = try(each.value.override_session_timeout, false)
  override_timeout             = try(each.value.override_timeout, null)
  override_half_closed_timeout = try(each.value.override_half_closed_timeout, null)
  override_time_wait_timeout   = try(each.value.override_time_wait_timeout, null)
}