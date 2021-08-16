#!/bin/bash
#
# commands to be run on ubuntu template in preparation to become template

set -ex

sudo apt update
sudo apt dist-upgrade -y

apt-install dnsutils traceroute -y

echo vm.swappiness=10 | sudo tee -a /etc/sysctl.conf
echo net.ipv6.conf.all.disable_ipv6=1 | sudo tee -a /etc/sysctl.conf
echo net.ipv6.conf.default.disable_ipv6=1 | sudo tee -a /etc/sysctl.conf
echo net.ipv6.conf.lo.disable_ipv6=1 | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

sudo sed -i 's/preserve_hostname: false/preserve_hostname: true/g' /etc/cloud/cloud.cfg

ls -l /etc/netplan
sudo rm /etc/netplan/*.yaml

history -c

sudo shutdown -h now
