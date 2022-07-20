data "google_compute_image" "toolkit_image" {
  project = var.project_id
  family  = var.image_family
}

resource "google_compute_instance" "looker_toolkit" {
  name         = var.instance_name
  machine_type = var.machine_type

  boot_disk {
    initialize_params {
      image = data.google_compute_image.toolkit_image.self_link
    }
  }

  network_interface {
    network = "default"

    access_config {

    }
  }
}
