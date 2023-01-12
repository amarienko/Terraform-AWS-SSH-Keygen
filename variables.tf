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

variable "algorithm" {
  description = <<-DESCR
    Name of the algorithm to use when generating the private key

    Module supported algorithms are: ED25519 and RSA.
  DESCR

  type     = string
  nullable = false
  default  = "ED25519"

  validation {
    condition = (try(
      var.algorithm != null) &&
      contains(["ED25519", "RSA"], var.algorithm)
    )
    error_message = "Module supported algorithms 'ED25519' and 'RSA'!"
  }
}

variable "rsa_bits" {
  description = "The size of the generated RSA key"
  type        = number
  nullable    = true
  default     = 4096

  validation {
    condition = (
      try(var.rsa_bits == 2048) ||
      try(var.rsa_bits == 3072) ||
      try(var.rsa_bits == 4096)
    )
    error_message = "Key size can be 2048, 3072 or 4096 bits (default: 4096)!"
  }
}
