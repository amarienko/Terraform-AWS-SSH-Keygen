# Variables declaration
/*
variable "region" {
  description = "AWS Region"
  type        = string
  default     = "eu-west-1"
}
*/

variable "all_tags" {
  description = "Global tags for each resource"
  type        = map(string)
  default     = {}
}

variable "domain" {
  description = "Full resources name suffix"
  type        = string
  nullable    = true
  default     = ""
}
