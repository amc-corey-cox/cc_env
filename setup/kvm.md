# KVM - Kernal-based Virtualization Machine
KVM is the Linux based hypervisor and virtualization manager. It is a prerequisite for Docker and a valuable Virtuallization manager in it's own right. Initially, we'll just set this up as needed for Docker but then I should generalize this for broader use and application.

## Install prerequisites for Docker
Docker requires KVM virtualization support and QEMU version 5.2 or newer, latest recommended.

First, we'll need to know what processor we have. Examine the output of the following command.
```
cat /proc/cpuinfo | less
```

Identify whether you have an Intel or AMD processor. Then we need to enable the kvm modules.
```
modprobe kvm
modprobe kvm_intel  # Intel processors
# modprobe kvm_amd    # AMD processors
```

Then we'll want to check to make sure the modules were loaded.
```
lsmod | grep kvm
```

On my current Intel setup, the output looks like this.
```
kvm_intel             487424  0
kvm                  1437696  1 kvm_intel
irqbypass              12288  1 kvm
```

Previously, on my AMD system output looked like this.
```
kvm_amd               167936  0
ccp                   126976  1 kvm_amd
kvm                  1089536  1 kvm_amd
irqbypass              16384  1 kvm
```

We'll need to add our user to the kvm group, which owns the device.
```
sudo usermod -aG kvm $USER
```

Then we'll look at the ownership of the kvm device.
```
ls -al /dev/kvm
groups $USER
```

Output should look like this.
```
crw-rw----+ 1 root kvm 10, 232 Jun  6 21:51 /dev/kvm
```
And the users groups should include `kvm`.


## Update Qemu to latest
Qemu is a machine emulator and virtualizer. Docker requires Qemu for installation on Linux. We may also use it for running other operating systems virtually, like Windows 11 pro.
First, we'll check to see if qemu installed.
```
/usr/bin/qemu-system-x86_64 --version
```
This will likely give an error, indicating that Qemu is not installed. While there are newer versions (9.01 and 8.2.4) of Qemu available they appear to require building from source. The version on apt is new enough (8.2.2), so I'll use it unless I learn I need newer features for something.
There are a few other packages that are recommended when installing Qemu for managing the virutalization environment.
```
sudo apt install qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils virtinst libvirt-daemon virt-manager
```
At this point, we should have KVM and Qemu sufficiently ready for Docker installation. Further setup will be added below, for other virtualization tasks such as Windows 11 pro.

