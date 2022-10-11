data "terraform_remote_state" "env_init" {
  backend = "s3"

  config = {
    bucket  = "obi-wan-bucket-labs"
    key     = "palo-firewall-workshop/01_env_init.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
}
