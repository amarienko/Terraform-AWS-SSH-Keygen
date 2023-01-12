/*
                                      -
                                      -----                           -
                                      ---------                      --
                                      ---------  -                -----
                                       ---------  ------        -------
                                         -------  ---------  ----------
                                            ----  ---------- ----------
                                              --  ---------- ----------
   Terraform module for  generating SSH        -  ---------- -------
   key pair to be used to control login           ---  ----- ---
   login access to AWS EC2 instances              --------   -
                                                  ----------
                                                  ----------
                                                   ---------
                                                       -----
                                                           -

  Amazon EC2 Key Pair Parameters

  Type:          ED25519 / RSA
  Length:        4096 / 3072 / 2048
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

resource "tls_private_key" "main" {
  # Generating public/private SSH key pair
  algorithm = var.algorithm
  rsa_bits  = var.rsa_bits

  depends_on = [
    random_string.key_name_suffix,
  ]
}


resource "aws_key_pair" "ssh_key_pair" {
  key_name = "${lower(var.algorithm)}-${random_string.key_name_suffix.result}"

  # `string` variable or file("path_to_keyfile.pub")
  public_key = tls_private_key.main.public_key_openssh

  tags = merge(
    {
      Name     = "${lower(var.algorithm)}-${random_string.key_name_suffix.result}"
      Resource = "key"
      FullName = "${
        lower(var.algorithm)
        }-${random_string.key_name_suffix.result
      }%{if var.domain != null && var.domain != ""}.key${var.domain}%{endif}"
    },
    var.all_tags
  )

  depends_on = [
    tls_private_key.main,
    random_string.key_name_suffix,
  ]
}


/*
  Export private and public `ssh` key-pair to file
*/
resource "local_sensitive_file" "private_key" {
  # sensitive data
  filename = "${path.root}/${
    lower(var.algorithm)}-${random_string.key_name_suffix.result
  }"
  file_permission = "0600"
  content         = tls_private_key.main.private_key_openssh

  depends_on = [
    tls_private_key.main,
  ]
}

resource "local_file" "public_key" {
  filename = "${path.root}/${
    lower(var.algorithm)}-${random_string.key_name_suffix.result
  }.pub"
  file_permission = "0644"
  content         = trimspace(tls_private_key.main.public_key_openssh)

  depends_on = [
    tls_private_key.main,
  ]
}
