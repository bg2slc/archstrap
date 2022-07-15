#!/bin/bash

#Intended for use AFTER disk partitioning, assuming:
#/dev/vda1 is /boot
#/dev/vda2 is /
#/dev/vda3 is swap

timedatectl set-ntp true

mkfs.ext4 /dev/vda1
mkfs.ext4 /dev/vda2
mkswap /dev/vda3

mount /dev/vda2 /mnt
mkdir /mnt/boot
mount /dev/vda1 /mnt/boot
swapon /dev/vda3

pacstrap /mnt base linux linux-firmware vi neovim awesome lightdm netctl grub

arch-chroot /mnt

genfstab -U /mnt >> /mnt/etc/fstab

ln -sf /usr/share/zoneinfo/Amercia/Toronto /etc/localtime
hwclock --systohc

nvim /etc/locale.gen &

locale-gen

echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "daedalus" > /etc/hostname

grub-install --target=i386-pc /dev/vda
grub-mkconfig -o /boot/grub/grub.cfg

echo "remember to create user useradd -m -G wheel USERNAME"
