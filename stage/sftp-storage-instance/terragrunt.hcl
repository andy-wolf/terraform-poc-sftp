locals {
  # Unfortunately inheritance of globals is not supported by terragrunt

  environment = "stage"
  component   = "sftp-storage-gateway"
  name        = "${local.environment}-${local.component}"
}

terraform {
  # Deploy version v0.0.3 in stage
  ###source = "git::git@github.com:foo/modules.git//app?ref=v0.0.3"
  source = "github.com/andy-wolf/terraform-modules.git//storage-gateway-instance"
}

include {
  path = find_in_parent_folders()
}

dependencies {
  paths = []
}

inputs = {
  //// Go with defaults
  // name
  // instance_type
  // tags
}



#prevent_destroy = true

