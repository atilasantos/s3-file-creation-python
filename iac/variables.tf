variable "region" {
  default = "sa-east-1"
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
  default = "qa-atila-santos-platform-challange"
}

variable "staging-bucket_name" {
  default = "staging-atila-santos-platform-challange"
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
