#!/bin/bash
#
# credits: based provied from https://github.com/tierrie/linux-scripts/blob/main/prepare-ubuntu-20.04.02-template.sh 
#
# synopsis: script patches an ubuntu machine, resets the hostname, resets the machine-id
#           and prepares for it to be templatized for vm
#           tested on ubuntu 22.04 LTS
#
# credits: base provided from https://github.com/jimangel/ubuntu-18.04-scripts
#

if [ `id -u` -ne 0 ]; then
	echo Need sudo
	exit 1
fi

set -v


# install latest packages and securit updates
sudo apt update -y
sudo apt dist-upgrade -y
sudo apt autoremove -y

# basic OS packages
sudo apt install jq vim git dos2unix zip unzip curl wget dnsutils traceroute swaks open-vm-tools -y

# install VMware agent package
sudo apt install -y open-vm-tools

# cleanup
sudo apt autoremove -y
sudo apt clean

# disable IPv6
echo net.ipv6.conf.all.disable_ipv6=1 | sudo tee -a /etc/sysctl.conf
echo net.ipv6.conf.default.disable_ipv6=1 | sudo tee -a /etc/sysctl.conf
echo net.ipv6.conf.lo.disable_ipv6=1 | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# Stop services for cleanup
sudo service rsyslog stop

#clear audit logs
if [ -f /var/log/wtmp ]; then
    sudo truncate -s0 /var/log/wtmp
fi
if [ -f /var/log/lastlog ]; then
    sudo truncate -s0 /var/log/lastlog
fi

# cleanup /tmp directories
sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/*

# cleanup current ssh keys
sudo rm -f /etc/ssh/ssh_host_*

# add check for ssh keys on reboot...regenerate if neccessary
cat << 'EOL' | sudo tee /etc/rc.local
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

# dynamically create hostname (optional)
if hostname | grep localhost; then
    hostnamectl set-hostname "$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo '')"
fi

test -f /etc/ssh/ssh_host_dsa_key || dpkg-reconfigure openssh-server
exit 0
EOL

# make sure the script is executable
sudo chmod +x /etc/rc.local

# reset hostname
# prevent cloudconfig from preserving the original hostname
sudo sed -i 's/preserve_hostname: false/preserve_hostname: true/g' /etc/cloud/cloud.cfg
sudo truncate -s0 /etc/hostname
sudo hostnamectl set-hostname localhost

# disable swap
sudo swapoff --all
sudo sed -ri '/\sswap\s/s/^#?/#/' /etc/fstab

# make machine-id unique and symlink it - ubuntu 20.04 uses machine id in the dhcp identifier and not mac addresses
sudo truncate -s 0 /etc/machine-id
sudo rm /var/lib/dbus/machine-id
sudo ln -s /etc/machine-id /var/lib/dbus/machine-id

# set dhcp to use mac - this is a little bit of a hack but I need this to be placed under the active nic settings
# also look in /etc/netplan for other config files
#sudo sed -i 's/optional: true/dhcp-identifier: mac/g' /etc/netplan/50-cloud-init.yaml

# cleans out all of the cloud-init cache / logs - this is mainly cleaning out networking info
sudo cloud-init clean --logs

# remove netplan file
sudo rm /etc/netplan/*.yaml

# cleanup shell history
cat /dev/null > ~/.bash_history && history -c

echo "run 'sudo shutdown -h now'"
