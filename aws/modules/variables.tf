variable "enable_roleA" {
  type    = bool
  default = false
}

variable "enable_roleB" {
  type    = bool
  default = false
}

variable "enable_roleC" {
  type    = bool
  default = false
}

variable "roleA_name" {
  type    = string
  default = ""
}

variable "roleB_name" {
  type    = string
  default = ""
}

variable "roleC_name" {
  type    = string
  default = ""
}

variable "roleC_account_id" {
  type    = string
  default = ""
}

variable "roleA_policy_document" {
  type    = string
  default = ""
}

variable "roleB_policy_document" {
  type    = string
  default = ""
}

variable "roleC_policy_document" {
  type    = string
  default = ""
}

variable "s3_bucket_name" {
  type    = string
  default = "example-bucket" 
}
variable "user_names" {
  type        = list(string)
  description = "List of user names to create."
}

variable "groups" {
  type        = map(list(string))
  description = "Map of groups and their users."
}

variable "group_policies" {
  type        = map(string)
  description = "JSON encoded IAM policies for each group."
}

