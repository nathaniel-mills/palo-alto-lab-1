terraform {
  backend "s3" {
    bucket = "obi-wan-bucket-labs"
    key    = "palo-firewall-workshop/01_env_init.tfstate"
    region = "eu-west-1"
  }
}
