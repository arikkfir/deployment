resource "google_service_account" "gha-arikkfir-deployment" {
  project      = google_project.project.project_id
  account_id   = "gha-arikkfir-deployment"
  display_name = "GitHub Actions: arikkfir/deployment"
}

resource "google_organization_iam_member" "gha-arikkfir-deployment" {
  for_each = toset([
    "roles/iam.organizationRoleViewer",
    "roles/resourcemanager.organizationViewer",
  ])

  org_id = data.google_organization.kfirfamily.org_id
  role   = each.key
  member = "serviceAccount:${google_service_account.gha-arikkfir-deployment.email}"
}

resource "google_project_iam_member" "gha-arikkfir-deployment" {
  for_each = toset([
    "roles/browser",
    "roles/container.clusterAdmin",
    "roles/compute.admin",
    "roles/iam.serviceAccountAdmin",
    "roles/resourcemanager.projectIamAdmin",
    "roles/serviceusage.serviceUsageAdmin",
  ])

  project = google_project.project.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.gha-arikkfir-deployment.email}"
}
