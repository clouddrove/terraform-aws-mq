provider "aws" {
  region = "us-east-1"
}

module "mq" {
  source      = "../../"
  name        = "mq"
  environment = "test"
}
