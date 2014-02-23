#!/bin/base

echo "RPi arch linux arm auto install script"
echo ""

echo ": change root password"
passwd

echo ": create www user account"
useradd -d /www www
passwd www
mkdir /www
cd
chown www www

echo ": change hostname"
echo "kkpi" > /etc/hostname

echo ": set up time zone"
rm /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

echo ": update packages and install partprobe for partition maintenance."
pacman --noconfirm -Syu
pacman --noconfirm -S parted

echo ": enhance partition space"
echo "d
2
n
e



n
l


w
"|fdisk /dev/mmcblk0
partprobe

echo ":: Make sure partprobe works and new partition information is loaded, 
then run another script to finish installation.
    otherwise please manually run 'reboot' to restart your rpi."

exit
