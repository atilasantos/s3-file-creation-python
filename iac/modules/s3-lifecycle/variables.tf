variable "lifecycle_rules" {
  type = list(object({
    id     = string
    status = string
    }
  ))
}
variable "bucket_id" {
  type = string
}

variable "prefix" {
  type = string
}
