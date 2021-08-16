variable "vsphere_user" {
  description = "vsphere username"
}

variable "vsphere_password" {
  description = "vsphere password"
}

variable "vsphere_server" {
  description = "vsphere_server"
}

variable "vsphere_datacenter" {
  description = "vsphere datacenter name"
}

variable "vsphere_datasource" {
  description = "vsphere_datasource"
}

variable "vsphere_cluster" {
  description = "vsphere_cluster"
}

variable "vsphere_network" {
  description = "vsphere_network"
}

variable "vsphere_template" {
  description = "vsphere_template"
}

variable "jumphost_name" {
  description = "jumphost_name"
}

variable "jumphost_domain" {
  description = "jumphost_domain"
}

variable "jumphost_ip" {
  description = "jumphost_ip"
}

variable "jumphost_cpu" { default=1 }
variable "jumphost_ram_mb" { default=1024 }
variable "jumphost_disk_gb" { default=30 }
variable "jumphost_vm_folder" { default="Jump-Seed-VM" }

variable "dns_server_list" { 
  type = list(string)
  default = [ ]
}
variable "dns_suffix_list" { 
  type = list(string)
  default = [ ]
}


variable "jumphost_subnet" {
  description = "jumphost_subnet"
}

variable "jumphost_gateway" {
  description = "jumphost_gateway"
}

