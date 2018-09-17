# Arch Linux

This sets up a clean install of Arch Linux.

# Arch Installation guide

### Connect to the internet
```
wifi-menu
```
`wifi-menu` is an easy way to connect wifi if no ethernet is available.
It comes with the ISO.

### Update the system clock

```
timedatectl set-ntp true
```

### Partition the disks
Use `fdisk -l` or `lsblk`' to identify the block devices.  
To partition the disk use:
```
fdisk /dev/sdX
```
where `X` stands for the disk name found with `fdisk -l`.

#### Create partitions
We will create five partition (one for a BIOS boot partition).
The four partitions are:
boot (500MB)
root (30 GB)
swap (150% of RAM)
bios boot (1MB)
home (Rest of available disk space)

#### Creating swap disk
Create a swap disk the size of your RAM.

```
mkswap /dev/sdxy
```
Warning: All data on the specified partition will be lost.
To enable the device for paging:
```
swapon /dev/sdxy
```

### Format the partitions

```
mkfs.ext4 /dev/sdXY
```
Where `X` and `Y` is the disk where you install Arch on.

### Mount the file systems
Firstly mount the root partition of `/mnt`.
Then `mkdir` the `boot` and `home` folder.
Mount the `boot` and `home` partition respectively.

```
mount /dev/sdXY/ /mnt
```

## Installation

### Install the base packages

```
pacstrap /mnt base base-devel connman wpa_supplicant
```

## Configure the system

### Fstab

```
genfstab -U /mnt >> /mnt/etc/fstab
```

### Chroot
Change root into the new system:

```
arch-chroot /mnt
```

### Time zone
Set the time zone:

```
ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
```

### Locale
Uncomment en_US.UTF-8 UTF-8 and other needed localizations in /etc/locale.gen, and generate them with:

```
locale-gen
```

Set the LANG variable in locale.conf(5) accordingly, for example:

```
echo LANG=en_US.UTF-8 > /etc/locale.conf
```

### Hostname
Create the hostname file
```
echo HOSTNAME > /etc/hostname
```

### Network configuration
Install the following packages to allow for wifi connection

```
pacman -S connman wpa_supplicant
```

Enable the connman service
```
systemctl enable connman.service
```

### Root password
Set the root password:

```
passwd
```

## Install bootloader
```
pacman -S grub
grub-install /dev/sdX
grub-mkconfig -o /boot/grub/grub.cfg
```

## Reboot

## Create user and add to sudoers
```
useradd -m -g users -s /bin/bash USER
passwd USER
```

Edit the sudoers file using either `visudo` or edit it via another text editer
```
/etc/sudoers
```

Add the user below root like:
```
root ALL=(ALL) ALL
USER ALL=(ALL) ALL
```

## Connecting to Wi-Fi
If the connman service has not been enabled yet enable it by
```
systemctl enable connman.service
```
next go into `connmanctl` to connect to a wifi access point you first have to enable
the technology `technologies`.
Enable `wifi` and then `scan <technology>` for available wifi access points.
To see the results of the scan use `services`.
Finally enable the agent `agent on` and connect to desired access point.
