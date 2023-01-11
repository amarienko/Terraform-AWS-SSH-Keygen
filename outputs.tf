/*
  SSH key pair details
*/
output "ssh__00__keypair_info" {
  value = {
    "Key Pair Name"      = aws_key_pair.ssh_key.key_name
    "Key Pair ID"        = aws_key_pair.ssh_key.key_pair_id
    "SHA256 Fingerprint" = aws_key_pair.ssh_key.fingerprint
  }

  depends_on = [
    tls_private_key.ed25519,
  ]
}

output "ssh__01__key_name" {
  value = {
    "key_pair_name" = aws_key_pair.ssh_key.key_name
  }
}


/*
  //
    Disabled Outputs
  //

output "ssh__02__ed25519_info" {
  description = "EC2 instance ssh key pair"
  value = {
    "Key ID"             = tls_private_key.ed25519.id
    "Key Algorithm"      = tls_private_key.ed25519.algorithm
    "Public Key"         = trimspace(tls_private_key.ed25519.public_key_openssh)
    "SHA256 Fingerprint" = tls_private_key.ed25519.public_key_fingerprint_sha256
  }
}

output "ssh__02__ed25519_sensitive" {
  # sensitive value
  description = "EC2 instance ssh key pair (sensitive)"
  sensitive   = true

  value = {
    "Key ID"      = tls_private_key.ed25519.id
    "Private Key" = tls_private_key.ed25519.private_key_openssh
  }
}
*/
