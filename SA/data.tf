data "terraform_remote_state" "rg" {
  backend = "remote"
  config = {
    organization = "naruby-riverlione-org"
    workspaces = {
      name = "Zero-RG"
    }
  }
}
