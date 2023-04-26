terraform {
	required\_providers {
	 google = {
	 source = "hashicorp/google"
	 version = "4.51.0"
		}
	}
}
provider "google" {
	credentials = file(var.credentials\_file)
	project = var.project
	region  = var.region
	zone    = var.zone
}
resource "google\_compute\_network" "vpc\_network" {
	name = "servis"
	}
resource "google\_compute\_subnetwork" "Labsubnet" {
	name = var.subnet\_name
	network = google\_compute\_network.vpc\_network.self\_link
	ip\_cidr\_range = "10.2.0.0/16"
	region= var.region
}
resource "google\_compute\_instance" "vm\_instance" {
	name = var.machine\_name
	machine\_type = "f1-micro"
	tags = ["djons", "esc", "githab", "laba", "matrics"]
	boot\_disk {
		initialize\_params {
			image = "debian-cloud/debian-11"
		}
	}
	network\_interface {
		network = google\_compute\_network.vpc\_network.name
		access\_config {
		}
	}
}
resource "google\_compute\_firewall" "vpc-network-allow" {
	name    = "letmein"
	network = google\_compute\_network.vpc\_network.self\_link
	allow {
		protocol = "tcp"
		ports    = ["80", "8080", "1000-2000"]
	}
	target\_tags = ["http-server","https-server"]
	source\_tags = ["vpc-network-allow"]
