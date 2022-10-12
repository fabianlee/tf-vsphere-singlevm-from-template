# vcenter credentials
vsphere_user          = "Administrator@vsphere.local"
vsphere_password      = "ExamplePass@456"
vsphere_server        = "vcenter.home.lab"
vsphere_datacenter    = "mydc1"
vsphere_datasource    = "datastore1"
vsphere_cluster       = "" # leave empty if no vcenter cluster
vsphere_network       = "admin141"

# name of template
vsphere_template      = "ubuntu-22"
# OS template credentials
jumphost_user         = "ubuntu"
jumphost_password     = "ExamplePass@456"

jumphost_name         = "ubuntu-22-vm"
jumphost_vm_folder    = "" # empty for root location
jumphost_domain       = "home.lab"
jumphost_cpu          = "2"
jumphost_ram_mb       = "2048"
jumphost_ip           = "192.168.141.7"
jumphost_subnet       = "24"
jumphost_gateway      = "192.168.141.1"
dns_server_list       = [ "192.168.141.1" ]
dns_suffix_list       = [ "home.lab" ]


