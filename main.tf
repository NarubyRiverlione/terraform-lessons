module "rg" {
  source     = "./modules/resource_group"
  environment = var.environment
  created_by  = var.created_by
}

module "sa" {
  source                  = "./modules/storage_account"
  environment             = var.environment
  created_by              = var.created_by
  resource_group_name     = module.rg.rg_name
  resource_group_location = module.rg.rg_location
  depends_on              = [module.rg] 
}