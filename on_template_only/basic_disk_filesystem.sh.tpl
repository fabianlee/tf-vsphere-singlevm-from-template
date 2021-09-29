#!/bin/bash
#
# Creates primary partition from device (/dev/sdX)
# then creates ext4 filesystem and adds fstab to disk
# non-LVM
#

# lvm mode
# creates independent Volume Group and Logical Volume for disk
function create_lvm_and_mount() {

# passed args
mydev="$1"
counter="$2"
mysize=$3
mountdir="$4"

dev="/dev/$mydev"
vgname="data$counter"
lvname="data$counter"

set -x
pvcreate $dev
pvs

vgcreate $vgname $dev
vgs

lvcreate --name $vgname -l 100%FREE $lvname
lvs
lvdisplay $lvname
set +x

mkfs.ext4 /dev/$vgname/$lvname

mkdir -p $mountdir
echo "/dev/$vgname/$lvname $mountdir ext4 defaults 0 0" >> /etc/fstab
mount $mountdir
echo "result of mount $mountdir is $?"

}

# non-lvm mode
# creates primary partition, initializes ext4 filesystem, then mounts filesystem at directory
function create_partition_and_mount() {

mydev="$1"
mysize=$2
mountdir="$3"

# make full size of device available, non-LVM
parted --script -a none /dev/$mydev \ unit s \ mklabel gpt \ mkpart primary 40s 100%
parted --script /dev/$mydev unit GB \ print free
sleep 5
lsblk

# make filesystem ext4, double dollar sign in tf template as escape (to keep tf from trying to replace)
mkfs.ext4 /dev/$${mydev}1

# fetch uuid so fstab permanent mount can be created
COUNTER=1
uuid=""
while [[ "$uuid" == "" && $COUNTER -lt 5 ]]; do
  uuid=$(lsblk -o name,uuid | grep $${mydev}1 | awk {'print $2'})
  echo "on $COUNTER try, uuid is $uuid"

  let COUNTER=COUNTER+1
  sleep 5
done

# create dir where disk will be mounted
mkdir -p $mountdir
echo "mkdir $mountdir retVal is $?"

# add to fstab for permanent mount
if ! grep -q $uuid /etc/fstab; then
  echo -e "UUID=$uuid $mountdir ext4 defaults 0 0" | tee -a /etc/fstab
else
  echo already have $uuid in /etc/fstab skipping
fi

sleep 1
mount $mountdir
echo "result of mount $mountdir is $?"

}

###### MAIN ##################################

# value comes from terraform templating
default_args="${default_args}"

# opportunity to override args from cli
disk_list=$${@:-$default_args}
echo "disk_list is $disk_list"

[ $EUID -eq 0 ] || { echo "ERROR script must run as sudo or root"; exit 1; }

LVM_DISK_INDEX=1
for disk in $disk_list; do
  echo "disk entry $disk"
  dev=$(echo $disk | awk -F, {'print $1'})
  lvm=$(echo $disk | awk -F, {'print $2'})
  sizeGB=$(echo $disk | awk -F, {'print $3'})
  dir=$(echo $disk | awk -F, {'print $4'})
  if [[ "$lvm" -eq "1" ]]; then
    echo "Need to create lvm partition on disk $dev of size $sizeGB at $dir"
    create_lvm_and_mount $dev $LVM_DISK_INDEX $sizeGB $dir
    let LVM_DISK_INDEX=LVM_DISK_INDEX+1
  else
    echo "Need to create non-lvm partition on disk $dev of size $sizeGB at $dir"
    create_partition_and_mount $dev $sizeGB $dir
  fi
done


echo "Illustrating a different way the parameters could have been passed via terraform templating"
%{ for disk in disks ~}
echo "need to create partition and mount on dev ${disk.dev} of size ${disk.sizeGB} at ${disk.dir} is lvm ${disk.lvm}?"
%{ endfor ~}
