#!/bin/bash

# pulls terraform variable values out of file
function getTFVal() {
  tfvarsfile=$1
  thevar=$2
  grep $thevar $tfvarsfile | awk '{print $3}' | sed 's/"//g'
}


jumphost_ip=$(getTFVal terraform.tfvars jumphost_ip)
jumphost_user=$(getTFVal terraform.tfvars jumphost_user)
jumphost_password=$(getTFVal terraform.tfvars jumphost_password)

set -x
sshpass -p $jumphost_password ssh $jumphost_user@$jumphost_ip

