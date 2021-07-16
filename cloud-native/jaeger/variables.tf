
variable "elasticsearch_password" {
  type        = string
  description = "Elasticsearch user password"

  validation {
    condition     = length(var.elasticsearch_password) >= 20
    error_message = "Elasticsearch password must be at least 20 characters."
  }
}
