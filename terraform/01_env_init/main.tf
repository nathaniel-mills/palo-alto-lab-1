locals {
  region         = "eu-west-1"
  sg_mgmt_name   = "${var.environment}-${var.name}-sg-mgmt"
  sg_client_name = "${var.environment}-${var.name}-sg-client"
  tags = {
    Terraform   = "true"
    Environment = "${var.environment}"
    User        = "${var.name}"
  }
}

module "keypair" {
  source  = "cloudposse/key-pair/aws"
  version = "0.18.0"

  namespace           = "palo-fw"
  stage               = var.environment
  name                = var.name
  generate_ssh_key    = true
  ssh_public_key_path = "../../.secrets"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "palo-fw-workshop-vpc-${var.name}"
  cidr = "10.0.0.0/16"

  azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = local.tags
}

resource "aws_eip" "palo-fw-mgmt_eip" {
  vpc = true

  tags = { "Name" = "palo-fw-workshop-${var.name}-eip-mgmt" }
}

resource "aws_eip" "palo-fw-public_eip" {
  vpc = true

  tags = { "Name" = "palo-fw-workshop-${var.name}-eip-public" }
}

resource "aws_security_group" "palo-fw_access" {
  name        = local.sg_mgmt_name
  description = "SG for palo-fw access"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ Name = local.sg_mgmt_name }, local.tags)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${var.my_ip}"]
  description       = "SSH access"
  security_group_id = aws_security_group.palo-fw_access.id
}

resource "aws_security_group_rule" "https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["${var.my_ip}"]
  description       = "HTTPs access"
  security_group_id = aws_security_group.palo-fw_access.id
}

resource "aws_security_group" "palo-fw_clients" {
  name        = local.sg_client_name
  description = "SG for palo-fw clients"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ Name = local.sg_client_name }, local.tags)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ssh_client" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "allow all inbound"
  security_group_id = aws_security_group.palo-fw_clients.id
}
