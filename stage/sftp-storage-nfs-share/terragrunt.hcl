locals {
  # Unfortunately inheritance of globals is not supported by terragrunt

  environment = "stage"
  component   = "sftp-nfs-share"
  name        = "${local.environment}-${local.component}"
}

terraform {
  # Deploy version v0.0.3 in stage
  ###source = "git::git@github.com:foo/modules.git//app?ref=v0.0.3"
  source = "github.com/andy-wolf/terraform-modules.git//storage-gateway-nfs-share"
}

include {
  path = find_in_parent_folders()
}

dependency "sftp-data-bucket" {
  config_path = "../sftp-data-bucket"

  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    bucket_arn = "fake-arn"
    kms_master_key_id = "fake-id"
    kms_master_key_arn = "fake-arn"
  }
}

dependency "sftp-storage-gateway" {
  config_path = "../sftp-storage-gateway"

  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    storage_gateway_arn = "fake-arn"
  }
}

dependencies {
  paths = ["../sftp-data-bucket", "../sftp-storage-gateway"]
}

inputs = {
  name = local.name

  storage_gateway_arn = dependency.sftp-storage-gateway.outputs.storage_gateway_arn
  data_bucket_arn = dependency.sftp-data-bucket.outputs.bucket_arn
  kms_key_arn = dependency.sftp-data-bucket.outputs.kms_master_key_arn
  kms_key_id  = dependency.sftp-data-bucket.outputs.kms_master_key_id
}



#prevent_destroy = true

