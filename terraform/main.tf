terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

# 1. GCS Raw Landing Bucket (Strict Encryption & Uniform Access)
resource "google_storage_bucket" "raw_landing" {
  name                        = "${var.gcp_project_id}-do-raw-landing"
  location                    = var.gcp_region
  force_destroy               = false
  uniform_bucket_level_access = true

  encryption {
    default_kms_key_name = var.kms_key_id
  }

  versioning {
    enabled = true
  }

  public_access_prevention = "enforced"
}

# 2. BigQuery Dataset (D1 Staged/Enforced)
resource "google_bigquery_dataset" "staged_enforced" {
  dataset_id                 = "d1_staged_enforced"
  friendly_name              = "D1 Staged Enforced Dataset"
  description                = "Strictly validated staging dataset with row-level security controls."
  location                   = var.gcp_region
  delete_contents_on_destroy = false

  access {
    role          = "OWNER"
    user_by_email = var.admin_service_account
  }

  access {
    role          = "READER"
    group_by_email = var.analytics_group_email
  }
}

# 3. BigQuery Row-Level Security (RLS) Policy
resource "google_bigquery_table" "student_onboarding" {
  dataset_id = google_bigquery_dataset.staged_enforced.dataset_id
  table_id   = "student_onboarding_staged"

  schema = jsonencode([
    { name = "student_id", type = "STRING", mode = "REQUIRED" },
    { name = "region_code", type = "STRING", mode = "REQUIRED" },
    { name = "is_eligible", type = "BOOLEAN", mode = "REQUIRED" }
  ])
}

resource "google_bigquery_row_access_policy" "regional_rls" {
  dataset_id = google_bigquery_dataset.staged_enforced.dataset_id
  table_id   = google_bigquery_table.student_onboarding.table_id
  policy_id  = "regional_access_filter"
  
  grantees = [
    "group:${var.regional_analysts_group}"
  ]

  predicate = "region_code = SESSION_USER()"
}