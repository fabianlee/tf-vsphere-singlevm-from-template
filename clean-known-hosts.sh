#!/bin/bash
#
# removes key from ssh known_hosts in case of host recreation

# terraform variables files
tfvars=terraform.tfvars

# pulls terraform variable values out of file
function getTFVal() {
  grep $1 $tfvars | awk '{print $3}' | sed 's/"//g'
}

############## MAIN ##################

# vCenter host
jumphost_ip=$(getTFVal jumphost_ip)

ssh-keygen -f ~/.ssh/known_hosts -R $jumphost_ip
