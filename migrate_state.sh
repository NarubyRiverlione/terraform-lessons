#!/usr/bin/env bash
set -euo pipefail

echo "Initializing migration for Resource Group (Zero-RG) into workspace Zero..."
terraform init -reconfigure \
  -backend-config="workspaces.name=Zero-RG" \


echo "Initializing migration for Storage Account (Zero-SA) into workspace Zero..."
terraform init -reconfigure \
  -backend-config="workspaces.name=Zero-SA" \


echo "State migration complete. All resources are now consolidated in the 'Zero' workspace."
