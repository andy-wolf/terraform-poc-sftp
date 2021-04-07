####################
# terragrunt.hcl
####################

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region = "eu-central-1"
}
EOF
}

remote_state {
  backend = "s3"
  config = {
    bucket         = "andywolf-terraform-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "my-lock-table"
  }
}

skip = true

