provider "panos" {
  hostname = var.hostname
  username = var.user
  password = var.password
}

module "sec_prof" {
  source = "sarah-blazic/security-profiles/panos"

  #for JSON files: try(jsondecode(file("<*.json>")), {})
  #for YAML files: try(yamldecode(file("<*.yaml>")), {})
  antivirus_file     = try(jsondecode(file("./files/json/antivirus.json")), {})
  file_blocking_file = try(jsondecode(file("./files/json/file_blocking.json")), {})
  wildfire_file      = try(jsondecode(file("./files/json/wildfire.json")), {})
  vulnerability_file = try(jsondecode(file("./files/json/vulnerability.json")), {})
  spyware_file       = try(jsondecode(file("./files/json/spyware.json")), {})
}


