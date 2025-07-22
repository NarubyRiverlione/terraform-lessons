data "terraform_remote_state" "rg" {
  backend = "local"
  config = {
    path = "../RG/terraform.tfstate"
  }
}