# provider "google" {
#   project = "330224828591"
#   region  = "us-east1"
# }

# resource "google_storage_bucket" "terraform_state" {
#   name     = "fedramao-gcp"
#   location = "US"

#   versioning {
#     enabled = true
#   }

#   lifecycle {
#     prevent_destroy = true
#     ignore_changes  = [name]
#   }
# }

# # backend.tf

# terraform {
#   backend "gcs" {
#     bucket = "fedramao-gcp"    # The bucket you created
#     prefix = "terraform/state" # Optional: prefix for state files
#     state  = "google-cloud-service.tfstate"
#   }
# }
