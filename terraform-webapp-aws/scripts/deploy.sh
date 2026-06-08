#!/usr/bin/env bash
set -euo pipefail

terraform init
terraform fmt -recursive
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
