# Terraform AWS SSH-Keygen
Simple Terraform module for generating `ed25519` or `rsa` SSH key pair to be used to control login access to AWS EC2 instances via SSH. The module generates AWS key pair and exports it to a OpenSSH ["Authorized Keys"](https://www.ssh.com/academy/ssh/authorized-keys-openssh#format-of-the-authorized-keys-file) format files in the root module directory.

The module only supports `ED25519` (default) and `RSA` key types. For `RSA` keys, you can set the size of the generated key, in bits (default size 4096). Supported key sizes `2048`, `3072` and `4096` bits.

This Terraform module was developed as an addition to the Terraform EC2 Instances module, but can be used independently.

### Module Usage
To use the module you need to add the following module definition block in the root module

```hcl
/*
  SSH-Keygen module
*/
module "ssh-keygen" {
  source = "github.com/amarienko/Terraform-AWS-SSH-Keygen"

  algorithm = "RSA"
  rsa_bits  = 2048
}
```
