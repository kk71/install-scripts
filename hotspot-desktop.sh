#!/bin/bash


#since the device name is always changing,
#so before everytime you run hostapd,
#please change the device name here.
devin="enp0s25"
devout="wlp0s26u1u2"

echo ": install hostapd into laptop"
echo "Must be run with root user!"
echo ""
#echo ": update repo info and install necessary tools"
#pacman --noconfirm -Syu
#pacman --noconfirm -S dhcp bind hostapd

echo "
interface=$devout
driver=nl80211
channel=11
ssid=kk-laptop
hw_mode=g
auth_algs=3
macaddr_acl=1
accept_mac_file=/etc/hostapd/hostapd.accept
" > /etc/hostapd/hostapd.conf

systemctl start hostapd

ip link set up dev $devout
ip addr add 192.168.3.1/24 dev $devout

sysctl net.ipv4.ip_forward=1

iptables -t nat -A POSTROUTING -o $devin -j MASQUERADE
iptables -A FORWARD -i $devout -o $devin -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

cd /etc
echo '
option domain-name-servers 199.91.73.222;
option subnet-mask 255.255.255.0;
option routers 192.168.3.1;
subnet 192.168.3.0 netmask 255.255.255.0 {
    range 192.168.3.1 192.168.3.254;
}
' > dhcpd.conf
systemctl start dhcpd4
