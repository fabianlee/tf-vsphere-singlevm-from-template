#!/bin/bash
#
# Usage: source ./source-govc-vars.sh
#
# exports variables needed to use govc by looking at terraform variables file
#

# terraform variables files
tfvars=terraform.tfvars

# pulls terraform variable values out of file
function getTFVal() {
  grep $1 $tfvars | awk '{print $3}' | sed 's/"//g'
}

############## MAIN ##################

# vCenter host
export GOVC_URL=$(getTFVal vsphere_server)
# vCenter credentials
export GOVC_USERNAME=$(getTFVal vsphere_user)
export GOVC_PASSWORD=$(getTFVal vsphere_password)
# disable cert validation
export GOVC_INSECURE=true

govc ls /
govc datacenter.info
