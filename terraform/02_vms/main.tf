locals {
  region = "eu-west-1"
  tags = {
    Terraform   = "true"
    Environment = "${var.environment}"
    User        = "${var.name}"
  }
}

resource "aws_network_interface" "firewall_mgmt" {
  subnet_id       = data.terraform_remote_state.env_init.outputs.public_subnets[2]
  description     = "${var.name}-iface-vm-mgmt"
  private_ips     = ["10.0.103.10"]
  security_groups = [data.terraform_remote_state.env_init.outputs.sg_mgmt_id]
  tags            = local.tags
}

resource "aws_network_interface" "firewall_public" {
  subnet_id       = data.terraform_remote_state.env_init.outputs.public_subnets[2]
  description     = "${var.name}-iface-vm-public"
  private_ips     = ["10.0.103.20"]
  security_groups = [data.terraform_remote_state.env_init.outputs.sg_mgmt_id]
  tags            = local.tags
}

resource "aws_network_interface" "firewall_private" {
  subnet_id         = data.terraform_remote_state.env_init.outputs.private_subnets[2]
  description       = "${var.name}-iface-vm-private"
  private_ips       = ["10.0.3.10"]
  security_groups   = [data.terraform_remote_state.env_init.outputs.sg_client_id]
  source_dest_check = "false"
  tags              = local.tags
}

resource "aws_eip_association" "eip_assoc_mgmt" {
  network_interface_id = aws_network_interface.firewall_mgmt.id
  allocation_id        = data.terraform_remote_state.env_init.outputs.eip_mgmt
  private_ip_address   = "10.0.103.10"
}

resource "aws_eip_association" "eip_assoc_public" {
  network_interface_id = aws_network_interface.firewall_public.id
  allocation_id        = data.terraform_remote_state.env_init.outputs.eip_public
  private_ip_address   = "10.0.103.20"
}

resource "aws_instance" "palo-fw_vm" {
  ami           = "ami-0e09f0e3c03b690e2"
  instance_type = "m5.large"

  key_name = data.terraform_remote_state.env_init.outputs.ssh_key_name


  network_interface {
    network_interface_id = aws_network_interface.firewall_mgmt.id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.firewall_public.id
    device_index         = 1
  }

  network_interface {
    network_interface_id = aws_network_interface.firewall_private.id
    device_index         = 2
  }
  root_block_device {
    volume_type           = "gp2"
    delete_on_termination = true
    encrypted             = true
  }

  tags = merge(
    {
      Name      = "${var.environment}-${var.name}-palo-fw-vm",
      "Tenable" = "FA"
    },
    local.tags
  )
}
