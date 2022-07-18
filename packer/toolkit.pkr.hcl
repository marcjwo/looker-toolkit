source "googlecompute" "looker-tooling" {
  source_image_family = "debian-11"
  ssh_username        = "packer"
  zone                = var.zone
  project_id          = var.project_id
  image_family        = "toolkit"
  name                = "toolkit image"
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
