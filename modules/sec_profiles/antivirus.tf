resource "panos_antivirus_security_profile" "this" {
  #for yaml files change jsondecode => yamldecode
  for_each = var.antivirus_file != "optional" ? { for virus in jsondecode(file(var.antivirus_file)) : virus.name => virus } : tomap({})

  name              = each.key
  device_group      = try(each.value.device_group, "shared")
  description       = try(each.value.description, null)
  packet_capture    = try(each.value.packet_capture, false)
  threat_exceptions = try(each.value.threat_exceptions, null)

  dynamic "decoder" {
    for_each = try(each.value.decoder, null) != null ? { for d in each.value.decoder : d.name => d } : {}
    content {
      name                    = decoder.value.name
      action                  = try(decoder.value.action, "default")
      wildfire_action         = try(decoder.value.wildfire_action, "default")
      machine_learning_action = try(decoder.value.machine_learning, null)
    }
  }

  dynamic "application_exception" {
    for_each = try(each.value.application_exception, null) != null ? { for app in each.value.application_exception : app.application => app } : {}
    content {
      application = application_exception.value.application
      action      = try(application_exception.value.action, "default")
    }
  }

  dynamic "machine_learning_model" {
    for_each = try(each.value.machine_learning_model, null) != null ? { for mod in each.value.machine_learning_model : mod.model => mod } : {}
    content {
      model  = machine_learning_model.value.model
      action = try(machine_learning_model.value.action, "disable")
    }
  }

  dynamic "machine_learning_exception" {
    for_each = try(each.value.machine_learning_exception, null) != null ? { for ex in each.value.machine_learning_exception : ex.name => ex } : {}
    content {
      name        = machine_learning_exception.value.name
      description = try(machine_learning_exception.value.description, null)
      filename    = try(machine_learning_exception.value.filename, null)
    }
  }

}