
in this version Terraform cloud (https://app.terraform.io/app/naruby-riverlione-org/workspaces/Zero-module) is used for both
* State storage
* Executing Terraform 
--> Azure Resource Management access via Terraform variable set "Azure Cred"
--> app registration with client id & secret

Github Action use terraform cli both the execution mode in the Terraform cloud is set to Remote.
During the setup of terraform in the Action the TF_API_TOKEN secret is use to connect to the Cloud.