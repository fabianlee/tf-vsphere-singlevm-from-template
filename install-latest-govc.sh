#!/bin/bash
# install latest version of govc
#

sudo apt install jq -y
ver=$(curl -qs https://api.github.com/repos/vmware/govmomi/releases/latest | jq -r ".tag_name")
echo going to install govc version $ver 

# -O output, -L follow
curl -L https://github.com/vmware/govmomi/releases/download/$ver/govc_Linux_x86_64.tar.gz -o /tmp/govc_Linux_x86_64.tar.gz

# make available for global execution
pushd .
cd /tmp
tar xvfz govc_Linux_x86_64.tar.gz
sudo cp govc /usr/local/bin/.
sudo chmod +x /usr/local/bin/govc
popd



