#!/bin/bash
#
# commands to be run on ubuntu template in preparation to become template

set -ex

sudo apt update
sudo apt dist-upgrade -y

sudo apt install dnsutils traceroute -y

echo vm.swappiness=10 | sudo tee -a /etc/sysctl.conf
echo net.ipv6.conf.all.disable_ipv6=1 | sudo tee -a /etc/sysctl.conf
echo net.ipv6.conf.default.disable_ipv6=1 | sudo tee -a /etc/sysctl.conf
echo net.ipv6.conf.lo.disable_ipv6=1 | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

if [ -f /etc/cloud/cloud.cfg ]; then
  sudo sed -i 's/preserve_hostname: false/preserve_hostname: true/g' /etc/cloud/cloud.cfg
fi

ls -l /etc/netplan
sudo rm -f /etc/netplan/*.yaml

# remove self
rm prepare_os_as_template.sh

history -c
sudo shutdown -h now
