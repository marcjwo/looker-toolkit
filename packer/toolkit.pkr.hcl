source "googlecompute" "looker-tooling" {
  impersonate_service_account = var.sa_email
  zone                        = var.zone
  project_id                  = var.project_id
  source_image_family         = "debian-11"
  ssh_username                = "packer"
  image_family                = "looker-toolkit"
  image_name                  = "looker-toolkit"
}

build {
  name    = "ansible"
  sources = ["sources.googlecompute.looker-tooling"]

  provisioner "shell" {
    inline = ["sleep 5"]
  }

  provisioner "ansible" {
    user          = "packer"
    playbook_file = var.tooling_playbook
  }
}
