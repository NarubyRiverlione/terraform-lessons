
in this version Terraform cloud (https://app.terraform.io/app/naruby-riverlione-org/workspaces/Zero-module) is used for only for
 State storage

Github Action use terraform cli both the execution mode in the Terraform cloud is set to Local.
During the setup of terraform in the Action the TF_API_TOKEN secret is use to connect to the Cloud to store the state.


--> Azure Resource Management access via Github Secret, map secrets to environments variables in terraform.yml 
--> app registration with client id & secret