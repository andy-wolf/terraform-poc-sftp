locals {
  # Unfortunately inheritance of globals is not supported by terragrunt

  environment = "stage"
  component   = "sftp-storage-gateway"
  name        = "${local.environment}-${local.component}"
}

terraform {
  # Deploy version v0.0.3 in stage
  ###source = "git::git@github.com:foo/modules.git//app?ref=v0.0.3"
  source = "github.com/andy-wolf/terraform-modules.git//storage-gateway"
}

include {
  path = find_in_parent_folders()
}

dependency "sftp-storage-instance" {
  config_path = "../sftp-storage-instance"

  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    instance_public_ip = "fake-ip"
    cache_volume_disk_path = "fake-disk-path"
  }
}

dependencies {
  paths = ["../sftp-storage-instance"]
}

inputs = {
  name = local.name

  gateway_ip = dependency.sftp-storage-instance.outputs.instance_public_ip

  cache_volume_disk_path = dependency.sftp-storage-instance.outputs.cache_volume_disk_path

  // tags
}



#prevent_destroy = true

