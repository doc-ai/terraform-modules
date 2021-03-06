variable "google_client_id" {
  type        = string
  default     = ""
  description = "oauth google client id not required if grafana dashboard is off"
}

variable "google_client_secret" {
  type        = string
  default     = ""
  description = "oauth google client secret not required if grafana dashboard is off"
}

variable "allowed_domains" {
  type        = string
  default     = "doc.ai"
  description = "oauth allowed domains not required if grafana dashboard is off"
}

variable "grafana_url" {
  type        = string
  default     = ""
  description = "public urls not required if grafana dashboard is off"
}

variable "grafana_enabled" {
  type        = bool
  default     = false
  description = "flag to turn grafana dashboard on/off"
}

variable "values_override" {
  type        = any
  default     = {}
  description = "values overrides for the chart"
}

variable "cluster_name" {
  type        = string
  default     = "dev-toniq-dev"
  description = "name of toniq cluster/deployment to send alerts for"
}
