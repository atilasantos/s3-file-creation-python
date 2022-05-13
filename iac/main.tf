module "qa-s3" {
  source = "./modules/s3"

  bucket_name = var.qa-bucket_name
  #   tags        = var.qa-tags
}

module "staging-s3" {
  source = "./modules/s3"

  bucket_name = var.staging-bucket_name
  #   tags        = var.staging-tags
}

module "qa-s3-lifecycle" {
  source = "./modules/s3-lifecycle"

  bucket_id       = module.qa-s3.bucket_id
  prefix          = var.qa-prefix
  lifecycle_rules = var.qa-lifecycle_rules
}

module "staging-s3-lifecycle" {
  source = "./modules/s3-lifecycle"

  bucket_id       = module.staging-s3.bucket_id
  prefix          = var.staging-prefix
  lifecycle_rules = var.staging-lifecycle_rules
}
