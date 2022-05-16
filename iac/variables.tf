variable "region" {
  default = "sa-east-1"
}

variable "qa-bucket_name" {
  default = "qa-atila-santos-platform-challange"
}

variable "staging-bucket_name" {
  default = "staging-atila-santos-platform-challange"
}

variable "lifecycle_rules" {
  default = [
    {
      id     = "rule-1"
      status = "Enabled"
    }
  ]
}

variable "envs" {
  default = {
    qa : "qa"
    staging : "staging"
  }
}
