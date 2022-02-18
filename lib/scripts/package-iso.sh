#!/bin/bash

# Echo commands run
set -x

# exit when any command fails
set -e

echo "Start of the Package ISO script"

pwd

ls

ls sharedVol

cd sharedVol

mkisofs -o jn.iso -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -J iso

ls

# VBoxManage convertdd rootfs.img disk.vmdk