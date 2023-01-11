/*
                                     -
                                     -----                           -
                                     ---------                      --
                                     ---------  -                -----
                                      ---------  ------        -------
                                        -------  ---------  ----------
                                           ----  ---------- ----------
                                             --  ---------- ----------
   Terraform module for generating            -  ---------- -------
   ed25519 SSH key pair to be used               ---  ----- ---
   to control login  access to AWS               --------   -
   EC2 instances                                 ----------
                                                 ----------
                                                  ---------
                                                      -----
                                                          -

  Amazon EC2 Key Pair Parameters

  Type:          ED25519
  Length:        4096
  Output Format: OpenSSH public key format

  Public Key Algorithm References

  RFC4253 The Secure Shell (SSH) Transport Layer Protocol, Section 6.6
  https://www.rfc-editor.org/rfc/rfc4253
  RFC4716 The Secure Shell (SSH) Public Key File Format
  https://www.ietf.org/rfc/rfc4716.txt
  RFC8709 Ed25519 and Ed448 Public Key Algorithms for the Secure Shell
          (SSH) Protocol
  https://www.rfc-editor.org/rfc/rfc8709
*/

resource "random_string" "key_name_suffix" {
  keepers = {}

  length      = 13
  special     = false
  lower       = true
  min_lower   = 8
  upper       = false
  min_upper   = 0
  numeric     = true
  min_numeric = 3
}

resource "tls_private_key" "ed25519" {
  # Generating public/private ed25519 key pair
  algorithm = "ED25519"
  rsa_bits  = 4096
}


resource "aws_key_pair" "ssh_key" {
  key_name = "ed25519-${random_string.key_name_suffix.result}"

  # `string` variable or file("path_to_keyfile.pub")
  public_key = tls_private_key.ed25519.public_key_openssh

  depends_on = [
    tls_private_key.ed25519,
    random_string.key_name_suffix,
  ]

  tags = merge(
    {
      Name     = "ed25519-${random_string.key_name_suffix.result}"
      Resource = "key"
      FullName = "ed25519-${random_string.key_name_suffix.result}.key.${var.domain}"
    },
    var.all_tags
  )
}


/*
  Export private and public `ssh` key-pair to file
  Res: https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file
*/
resource "local_sensitive_file" "private_key" {
  # sensitive data
  content         = tls_private_key.ed25519.private_key_openssh
  filename        = "${path.root}/ed25519-${random_string.key_name_suffix.result}"
  file_permission = "0600"

  depends_on = [
    tls_private_key.ed25519,
  ]
}

resource "local_file" "public_key" {
  content         = trimspace(tls_private_key.ed25519.public_key_openssh)
  filename        = "${path.root}/ed25519-${random_string.key_name_suffix.result}.pub"
  file_permission = "0644"

  depends_on = [
    tls_private_key.ed25519,
  ]
}
