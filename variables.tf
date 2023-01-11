# Variables declaration
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
