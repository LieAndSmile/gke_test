provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}
# VPC Network
resource "google_compute_network" "vpc_network" {
  name                    = "devops-lab-network"
  auto_create_subnetworks = false
}

# Subnetwork
resource "google_compute_subnetwork" "gke_subnet" {
  name          = "devops-lab-subnet"
  ip_cidr_range = "10.0.0.0/16"
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

# GKE Cluster
resource "google_container_cluster" "gke_cluster" {
  name     = "devops-lab"
  location = var.zone

  network    = google_compute_network.vpc_network.id
  subnetwork = google_compute_subnetwork.gke_subnet.id

  initial_node_count = 1

  node_config {
    machine_type = "e2-medium"
    preemptible  = true
  }
}
