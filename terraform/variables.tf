variable "gcp_project_id" {
  type        = string
  description = "The target Google Cloud Platform project identification string."
  default     = "habot-staging-project"
}

variable "gcp_region" {
  type        = string
  description = "The primary Google Cloud deployment region."
  default     = "me-central1" # Middle East (Dubai) region
}

variable "kms_key_id" {
  type        = string
  description = "The fully qualified resource link for the Cloud KMS encryption key."
  default     = "projects/habot-staging-project/locations/me-central1/keyRings/habot-keyring/cryptoKeys/raw-landing-key"
}

variable "admin_service_account" {
  type        = string
  description = "The primary administrative service account email address."
  default     = "terraform-admin@habot-staging-project.iam.gserviceaccount.com"
}

variable "analytics_group_email" {
  type        = string
  description = "The Google Group email address for regional analytics users."
  default     = "analytics-team@habot.io"
}

variable "regional_analysts_group" {
  type        = string
  description = "Google Group identifier assigned to regional access control filters."
  default     = "regional-analysts@habot.io"
}