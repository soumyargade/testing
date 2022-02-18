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
6. Configure the VirtualBox VM.
``` bash
VBoxManage createvm --name jn --register
VBoxManage storagectl jn --name IDE --add ide
VBoxManage storageattach jn --storagectl IDE --port 0 --device 0 --type dvddrive --medium jn.iso
VBoxManage storagectl jn --name SCSI --add scsi
VBoxManage storageattach jn --storagectl SCSI --port 1 --device 0 --type hdd --medium disk.vmdk
VBoxManage modifyvm jn --memory 1024 --cpus 1
VBoxManage modifyvm jn --uart1 0x3f8 4 --uartmode1 disconnected
VBoxManage modifyvm jn --nic1 nat
VBoxManage modifyvm jn --nictype1 virtio
VBoxManage modifyvm jn --natpf1 "jupyter,tcp,,8888,,8888"
```
7. Go to VirtualBox, click on the VM labeled `jn` & hit "Start".
8. Login to the VM with username "ubuntu" & password "ubuntu".
9. Make sure you're able to `ping 8.8.8.8`.
``` bash
cd ../..
sudo netplan apply
sudo netplan generate
ping 8.8.8.8
```
10. Add `ubuntu` to etc/hosts file.
11. Start up the Jupyter Notebook.
``` bash
jupyter notebook password
cp data/titanic.csv ~/.jupyter/titanic.csv
cd ~/.jupyter
sudo jupyter notebook --allow-root --ip=0.0.0.0
```
12. Open browser & go to `127.0.0.1:8888`.
13. Enter in password created in step #11 & paste in code snippet.
``` python
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

titanic = pd.read_csv('/data/titanic.csv')

# Countplot
sns.catplot(x ="Sex", hue ="Survived",
kind ="count", data = titanic)
```

## Provisioning Script (20)

## Screencast (10)
* Building a Virtual Machine Image - https://youtu.be/6FeWXH9TXdk.
* Provisioning Script - 
