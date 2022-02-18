#!/bin/bash

# Echo commands run
set -x

# exit when any command fails
set -e

echo "Running rootfs build script"

# create raw disk with 50M
dd if=/dev/zero of=rootfs.img bs=1G count=3

# format disk with ext4 filesystem
mkfs.ext4 rootfs.img -L cloudimg-rootfs

# mount disk
mkdir -p /rootfs
mount -o loop rootfs.img /rootfs

# download & extract appropriate base rootfs
wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64-root.tar.xz
tar -xf focal-server-cloudimg-amd64-root.tar.xz -C rootfs

chroot rootfs bash -c "groupadd -r ubuntu && useradd -m -r -g ubuntu ubuntu -s /bin/bash"
chroot rootfs bash -c "echo 'ubuntu ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers"
chroot rootfs bash -c "echo 'ubuntu:ubuntu' | chpasswd"

# to fix resolv.conf issues
chroot rootfs rm /etc/resolv.conf
echo "nameserver 8.8.8.8" | tee rootfs/etc/resolv.conf
chroot rootfs apt update

# python stuff
chroot rootfs apt-get install python3.9 -y
chroot rootfs apt-get install python3-pip -y
chroot rootfs apt-get install python3-notebook -y

chroot rootfs pip3 install pandas
chroot rootfs pip3 install seaborn

# save csv file to data
mkdir -p /rootfs/data
wget https://raw.githubusercontent.com/datasciencedojo/datasets/master/titanic.csv -P /rootfs/data

# sanity check
ls rootfs/data

cp -R /rootfs/data /sharedVol

# install linux-virtual apt package
chroot rootfs apt-get install linux-virtual -y

# sanity check
ls rootfs/boot

# make iso directory & sub-directories
mkdir iso
mkdir iso/isolinux
mkdir iso/boot

# copy stuff into boot
cp -L rootfs/boot/vmlinuz iso/boot
cp -L rootfs/boot/initrd.img iso/boot

# copy stuff into isolinux
cp -L syslinux/isolinux.bin iso/isolinux
cp -L syslinux/isolinux.cfg iso/isolinux
cp -L syslinux/ldlinux.c32 iso/isolinux

cp -R iso /sharedVol/iso

# sanity check
ls iso
ls iso/boot
ls iso/isolinux

# unmount
umount rootfs

cp --sparse=always rootfs.img /sharedVol/rootfs.img

ls

ls sharedVol

# mkisofs -o jn.iso -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -J iso
# ls syslinux