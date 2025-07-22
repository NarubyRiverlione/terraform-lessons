#!/bin/bash
set -e

create() {
  echo "Creating resources..."
  # Navigate to the RG directory and run terraform apply
  cd RG
  terraform init
  terraform apply -auto-approve
  # Navigate to the SA directory and run terraform apply
  cd ../SA
  terraform init
  terraform apply -auto-approve
  # Navigate back to the root directory
  cd ..
  echo "Resources created."
}

destroy() {
  echo "Destroying resources..."
  # Navigate to the SA directory and run terraform destroy
  cd SA
  terraform init
  terraform destroy -auto-approve
  # Navigate to the RG directory and run terraform destroy
  cd ../RG
  terraform init
  terraform destroy -auto-approve
  # Navigate back to the root directory
  cd ..
  echo "Resources destroyed."
}

usage() {
  echo "Usage: $0 {create|destroy}"
  exit 1
}

# Dispatch based on the first argument
case "$1" in
  create)
    create
    ;;
  destroy)
    destroy
    ;;
  *)
    usage
    ;;
esac
