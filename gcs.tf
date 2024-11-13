provider "google" {
  project = "330224828591"
  region  = "us-east1"
}

resource "google_storage_bucket" "terraform_state" {
  name     = "fedramao-gcp"
  location = "US"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}
