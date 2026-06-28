terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  
  # Point this to your successfully created bootstrap bucket
  backend "gcs" {
    bucket = "tf-state-dark-gateway-398321"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.project_id
  region  = "us-east1"
}

# A random suffix generator to ensure project IDs don't collide globally
resource "random_id" "project_suffix" {
  byte_length = 4
}

# 1. Commission the Staging Project
resource "google_project" "staging" {
  name            = "Sandbox-Staging"
  project_id      = "sb-staging-${random_id.project_suffix.hex}"
  billing_account = var.billing_account_id
}

# 2. Commission the Production Project
resource "google_project" "production" {
  name            = "Sandbox-Production"
  project_id      = "sb-prod-${random_id.project_suffix.hex}"
  billing_account = var.billing_account_id
}
