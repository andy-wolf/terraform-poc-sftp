locals {
  # Unfortunately inheritance of globals is not supported by terragrunt

  environment = "stage"
  component   = "sftp-data-bucket"
  name        = "${local.environment}-${local.component}"
}

terraform {
  # Deploy version v0.0.3 in stage
  ###source = "git::git@github.com:foo/modules.git//app?ref=v0.0.3"
  source = "github.com/andy-wolf/terraform-modules.git//s3-bucket"
}

include {
  path = find_in_parent_folders()
}

dependencies {
  paths = []
}

inputs = {
  name = local.name

  folders = ["sftp-server/", "sftp-bridge/"]
}




#prevent_destroy = true

