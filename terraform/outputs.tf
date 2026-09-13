output "raw_landing_bucket_name" {
  value       = google_storage_bucket.raw_landing.name
  description = "The full name of the provisioned GCS raw landing bucket."
}

output "raw_landing_bucket_url" {
  value       = google_storage_bucket.raw_landing.url
  description = "The storage URL scheme for the raw landing bucket."
}

output "bigquery_dataset_id" {
  value       = google_bigquery_dataset.staged_enforced.dataset_id
  description = "The dataset identifier for the BigQuery D1 staged dataset."
}

output "bigquery_table_id" {
  value       = google_bigquery_table.student_onboarding.table_id
  description = "The table identifier for student onboarding staged records."
}