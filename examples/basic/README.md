# terraform-aws-mq basic example

This is a basic example of the `terraform-aws-mq` module.

## Usage

```hcl
module "mq" {
  source      = "clouddrove/mq/aws"
  name        = "mq"
  environment = "test"
}
```
