# Terraform script to provision an Oracle Autonomous Database on OCI
# Part of Stage 8 - Cloud Ecosystem

resource "oci_database_autonomous_database" "enterprise_adb" {
  admin_password           = var.db_admin_password
  compartment_id           = var.compartment_ocid
  cpu_core_count           = var.is_free_tier ? 1 : 4
  data_storage_size_in_tbs = var.is_free_tier ? 1 : 10
  db_name                  = "entcore"
  display_name             = "EnterpriseCoreDB"
  db_workload              = "OLTP"
  is_free_tier             = var.is_free_tier
  license_model            = "LICENSE_INCLUDED"
}

variable "compartment_ocid" {
  description = "OCID of the compartment where the DB will be created"
  type        = string
}

variable "db_admin_password" {
  description = "Sensitive admin password for the database"
  sensitive   = true
}

variable "is_free_tier" {
  description = "Set to true to provision Always Free autonomous DB (Default to prevent accidental billing)"
  type        = bool
  default     = true # Default to true for safe local sandbox deployment
}

output "adb_connection_urls" {
  value = oci_database_autonomous_database.enterprise_adb.connection_urls
}
