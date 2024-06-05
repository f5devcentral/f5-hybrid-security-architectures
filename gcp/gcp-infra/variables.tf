variable "region" {
  description = "GCP region name"
  type        = string
  default     = "asia-south1"
}

variable "cidr" {
  description = "CIDR to create subnet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "project_id" {
  description = "GCP project id"
  type        = string
}

variable "project_prefix" {
  type        = string
  description = "This value is inserted at the beginning of each cloud object (alpha-numeric, no special character)"
}

variable "gke_num_nodes" {
  default     = 1
  description = "number of gke nodes"
}