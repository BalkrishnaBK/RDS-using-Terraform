output "db_address" {
  value = module.db.db_instance_address
}

output "db_port" {
  value = module.db.db_instance_port
}

output "db_endpoint" {
  value = module.db.db_instance_endpoint
}

output "db_instance_name" {
  value = module.db.db_instance_name
}

output "db_userName" {
  value = module.db.db_instance_username
  sensitive = true
}

output "db_subnet_id" {
  value = module.db.db_subnet_group_id
}

