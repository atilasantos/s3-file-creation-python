resource "aws_s3_bucket_lifecycle_configuration" "s3-lifecycle" {
  bucket = var.bucket_id

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      id = rule.value["id"]
      expiration {
        days = 1
      }
      status = rule.value["status"]
    }
  }
}
