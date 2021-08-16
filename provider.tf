terraform {
  required_version = ">= 0.14.7"
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"

      version = "1.26.0"

      # errors with customization scripts, allow 2.0 to be tested by community more
      #version = "2.0.0"
    }
  }
}

provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server
  allow_unverified_ssl = true
}



