variable "region" {
  default = "sa-east-1"
}

variable "qa-prefix" {
  default = "qa"
}

variable "staging-prefix" {
  default = "staging"
}

variable "qa-tags" {
  default = {
    env         = "qa"
    cost_center = "devops"
  }
}

variable "staging-tags" {
  default = {
    env         = "staging"
    cost_center = "devops"
  }
}

variable "qa-bucket_name" {
  default = "qa-s3-file-creation"
}

variable "staging-bucket_name" {
  default = "staging-s3-file-creation"
}

variable "qa-lifecycle_rules" {
  default = [
    {
      id     = "rule-1"
      status = "Enabled"
    }
  ]
}

variable "staging-lifecycle_rules" {
  default = [
    {
      id     = "rule-1"
      status = "Enabled"
    }
  ]
}
