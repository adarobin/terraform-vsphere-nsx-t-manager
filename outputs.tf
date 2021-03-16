output "root_password" {
  value       = random_password.root_password.result
  sensitive   = true
  description = "The root password generated for the NSX-T Manager"
}

output "admin_password" {
  value       = random_password.admin_password.result
  sensitive   = true
  description = "The admin password generated for the NSX-T Manager"
}

output "audit_password" {
  value       = random_password.audit_password.result
  sensitive   = true
  description = "The audit password generated for the NSX-T Manager"
}
