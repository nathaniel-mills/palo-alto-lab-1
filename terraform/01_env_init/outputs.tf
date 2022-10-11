output "ssh_key_name" {
  value = module.keypair.key_name
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "eip_mgmt" {
  value = aws_eip.palo-fw-mgmt_eip.id
}

output "eip_mgmt_value" {
  value = aws_eip.palo-fw-mgmt_eip.public_ip
}

output "eip_public" {
  value = aws_eip.palo-fw-public_eip.id
}

output "sg_mgmt_id" {
  value = aws_security_group.palo-fw_access.id
}

output "sg_client_id" {
  value = aws_security_group.palo-fw_clients.id
}
