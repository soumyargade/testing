# HW2-srgade-DevOps
## Building a Virtual Machine Image (70)
Follow the instructions below to run the program:
1. Clone this repo & cd into it.
``` bash
git clone https://github.ncsu.edu/CSC-DevOps-S22/HW2-srgade-DevOps.git
cd HW2-srgade-DevOps
```
2. Install necessary node packages.
``` bash
npm i
npm link
```
3. Build the custom docker image.
``` bash
p init
```
4. Build rootfs, extract kernel, initrd and package as iso.
``` bash
p build
```
5. Convert image to VMDK disk within the shared volume.
``` bash
cd sharedVol
VBoxManage convertdd rootfs.img disk.vmdk
```

## Provisioning Script (20)

## Screencast (10)
* Building a Virtual Machine Image - 
* Provisioning Script - 
