locals {
  # Unfortunately inheritance of globals is not supported by terragrunt

  environment = "stage"
  component   = "sftp-server"
  name        = "${local.environment}-${local.component}"
}

terraform {
  # Deploy version v0.0.3 in stage
  ###source = "git::git@github.com:foo/modules.git//app?ref=v0.0.3"
  source = "github.com/andy-wolf/terraform-modules.git//sftp-server"
}

include {
  path = find_in_parent_folders()
}

dependencies {
  paths = []
}

inputs = {
  name = local.name

  identity_provider_type = "SERVICE_MANAGED"
  endpoint_type          = "PUBLIC"
}




#prevent_destroy = true

