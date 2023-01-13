<p align="left">
    <a href="https://developer.hashicorp.com/terraform/downloads" alt="Terraform">
    <img src="https://img.shields.io/badge/terraform-%3E%3D1.2-blueviolet" /></a>
    <a href="https://opensource.org/licenses/MIT" alt="License">
    <img src="https://img.shields.io/github/license/amarienko/Terraform-AWS-SSH-Keygen?color=yellow" /></a>
</p>

# Terraform AWS SSH-Keygen
Simple Terraform module for generating `ed25519` or `rsa` SSH key pair to be used to control login access to AWS EC2 instances via SSH. The module generates AWS key pair and exports it to a OpenSSH ["Authorized Keys"](https://www.ssh.com/academy/ssh/authorized-keys-openssh#format-of-the-authorized-keys-file) format files in the root module directory.

The module only supports `ED25519` (default) and `RSA` key types. For `RSA` keys, you can set the size of the generated key, in bits (default size 4096). Supported key sizes `2048`, `3072` and `4096` bits.

This Terraform module was developed as an addition to the Terraform EC2 Instances module, but can be used independently.

### Module Usage
To use the module you need to add the following module definition block in the root module

```hcl
/*
  'SSH-Keygen' module definition
*/
module "ssh-keygen" {
  source = "github.com/amarienko/Terraform-AWS-SSH-Keygen"

  algorithm = "RSA"
  rsa_bits  = 2048
}
```

### Inputs
| Name | Description | Type | Default |
|------|-------------|:------:|:---------:|
| algorithm | (Optional) Name of the algorithm to use when generating the private key. | `string` | "ED25519"
| rsa_bits | (Optional) The size of the generated RSA key in bits | `number` | 4096 |
| all_tags | (Optional) User defined map of tags to add to `aws_key_pair` resource | `map(string)` | {} |
| domain | (Optional) User difined objects tree | `string` | "" |

### Outputs
| Name | Description |
|------|-------------|
| ssh\_\_00\_\_keypair_info | Includes general information about the generated key pair: key pair name, key pair ID and fingerprint of public key data, described in Section 4 of RFC4716 |
| ssh\_\_01\_\_key_name | The key pair name |

### Complex example
```hcl
/*
  Initial local variables definition
*/
locals {
  all_tags = merge(
    {
      UUID = uuidv5("dns",
        "${var.environment}.${var.namespace}.${var.region}.${var.cloud_provider}"
      )
      Provider    = var.cloud_provider
      Tool        = var.tool
      Namespace   = var.namespace
      Environment = var.environment
      Group       = "${var.environment}.${var.namespace}.${var.region}.${var.cloud_provider}"
    },
    var.user_tags,
  )
}

/*
  'SSH-Keygen' module
*/
module "ssh-keygen" {
  source = "github.com/amarienko/Terraform-AWS-SSH-Keygen"

  algorithm = "ED25519"
  all_tags = local.all_tags
}

/*
  Output: Key pair details
*/
output "ec2__00__keypair" {
  value = module.ssh-keygen.ssh__00__keypair_info
}
```

### Providers
| Name | Version |
|------|-------------|
| [aws](https://registry.terraform.io/providers/hashicorp/aws) | ~> 4.0 |
| [tls](https://registry.terraform.io/providers/hashicorp/tls) | ~> 4.0.1 |
| [random](https://registry.terraform.io/providers/hashicorp/random) | ~> 3.0 |
| [local](https://registry.terraform.io/providers/hashicorp/local) | ~> 2.2 |

### References
* [RFC 4253](https://www.rfc-editor.org/rfc/rfc4253) The Secure Shell (SSH) Transport Layer Protocol
* [RFC 4716](https://www.ietf.org/rfc/rfc4716.txt) The Secure Shell (SSH) Public Key File Format
* [RFC 8709](https://www.rfc-editor.org/rfc/rfc8709) Ed25519 and Ed448 Public Key Algorithms for the Secure Shell (SSH) Protocol
