locals {
  # Unfortunately inheritance of globals is not supported by terragrunt

  environment = "stage"
  component   = "sftp-server-user1"
  name        = "${local.environment}-${local.component}"
}

terraform {
  # Deploy version v0.0.3 in stage
  ###source = "git::git@github.com:foo/modules.git//app?ref=v0.0.3"
  source = "github.com/andy-wolf/terraform-modules.git//sftp-server-user"
}

include {
  path = find_in_parent_folders()
}

dependency "sftp-server" {
  config_path = "../sftp-server"

  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    transfer_server_id   = "fake-id"
  }
}

dependency "sftp-data-bucket" {
  config_path = "../sftp-data-bucket"

  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    bucket_name = "fake-name"
    kms_master_key_id = "fake-id"
  }
}

dependencies {
  paths = ["../sftp-server", "../sftp-data-bucket"]
}

inputs = {
  username = local.name

  data_bucket_name   = dependency.sftp-data-bucket.outputs.bucket_name
  data_bucket_master_key_id = dependency.sftp-data-bucket.outputs.kms_master_key_id

  server_id   = dependency.sftp-server.outputs.transfer_server_id
}



#prevent_destroy = true

