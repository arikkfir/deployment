variable "gcp_project" {
  type        = string
  description = "GCP project."
}

variable "gcp_region" {
  type        = string
  description = "Region to place compute resources."
}

variable "gcp_zone" {
  type        = string
  description = "Zone to place compute resources."
}

variable "gcp_billing_account" {
  type        = string
  description = "Billing account ID"
}

resource "google_project" "project" {
  skip_delete     = true
  project_id      = var.gcp_project
  name            = var.gcp_project
  org_id          = data.google_organization.kfirfamily.org_id
  billing_account = var.gcp_billing_account
}

resource "google_storage_bucket" "arikkfir-devops" {
  name                        = "arikkfir-devops"
  location                    = "EU"
  project                     = google_project.project.project_id
  storage_class               = "MULTI_REGIONAL"
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_member" "arikkfir-devops-gha-arikkfir-deployment" {
  for_each = toset([
    "roles/storage.admin",
    "roles/storage.objectAdmin",
  ])

  bucket = google_storage_bucket.arikkfir-devops.name
  role   = each.key
  member = "serviceAccount:${google_service_account.gha-arikkfir-deployment.email}"
}
