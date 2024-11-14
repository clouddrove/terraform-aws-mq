# ------------------------------------------------------------------------------
# Outputs
# ------------------------------------------------------------------------------
output "label_order" {
  value       = local.label_order
  description = "Label order."
}

# If you want to add more outputs related to VPC, Subnet, and Security Groups, you can uncomment and customize as needed.

# output "vpc_id" {
#   value = module.vpc.vpc_id
# }

# output "subnet_ids" {
#   value = module.public_subnet.subnet_ids
# }

# output "security_group_ids" {
#   value = module.security_group.security_group_id
# }

# output "vpc_cidr_block" {
#   value = aws_vpc.this.cidr_block
# }

# output "subnet_id" {
#   value = aws_subnet.this.id
# }
