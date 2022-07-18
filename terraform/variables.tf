variable "instance_name" {
  description = "Instance Name"
  default = "Looker PS Toolkit"
}

variable "project_id" {
  description = "Project ID"
}

variable "zone" {
  description = "Zone"
  default = "europe-west3-c"
}

variable "region" {
  description = "Region"
  default = "europe-west3"
}

variable "machine_type" {
  description = "Machine type"
  default = "f1-micro"
}

variable "image" {
  description = "Image"
  default = "debian-cloud/debian-11"
}

variable "image_family" {
  description = "Image family to be used by TF"
  default = "looker-toolkit"
}

# variable "startup_script" {
#   description = "Path to the startup script"
# }

variable "sa_email" {
  description = "Service Account Email"
}
