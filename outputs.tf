/*
  SSH key pair details
*/
output "ssh__00__keypair_info" {
  value = {
    "Key Pair Name"      = aws_key_pair.ssh_key_pair.key_name
    "Key Pair ID"        = aws_key_pair.ssh_key_pair.key_pair_id
    "SHA256 Fingerprint" = aws_key_pair.ssh_key_pair.fingerprint
  }

  depends_on = [
    tls_private_key.main,
  ]
}

output "ssh__01__key_name" {
  value = {
    "key_pair_name" = aws_key_pair.ssh_key_pair.key_name
  }
}


/*
  //
    Disabled Outputs
  //

output "ssh__02__key_info" {
  description = "EC2 instance ssh key pair"
  value = {
    "Key ID"             = tls_private_key.main.id
    "Key Algorithm"      = tls_private_key.main.algorithm
    "Public Key"         = trimspace(tls_private_key.main.public_key_openssh)
    "SHA256 Fingerprint" = tls_private_key.main.public_key_fingerprint_sha256
  }
}

output "ssh__02__key_sensitive" {
  # sensitive value
  description = "EC2 instance ssh key pair (sensitive)"
  sensitive   = true

  value = {
    "Key ID"      = tls_private_key.main.id
    "Private Key" = tls_private_key.main.private_key_openssh
  }
}
*/
