terraform {
  backend "s3" {
    bucket = "obi-wan-bucket-labs"
    key    = "palo-firewall-workshop/02_vms.tfstate"
    region = "eu-west-1"
  }
}
