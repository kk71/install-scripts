#!/bind/bash

echo ": update repo info and install necessary tools"
pacman --noconfirm -Syu
pacman --noconfirm -S dhcp bind hostapd

#replace hostapd to a version that support rtl8192cu chipset
cd /sbin
mv hostapd hostapd.bak
wget https://dl.dropbox.com/u/1663660/hostapd/hostapd
chmod +x hostapd
echo '
interface=wlan0
driver=rtl871xdrv
channel=11
ssid=kk-RaspberryPI
hw_mode=g
auth_algs=3

wpa=3
wpa_passphrase=fkcomputerbill
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
wpa_ptk_rekey=600
' > /etc/hostapd/hostapd.conf

cd
echo '
ip link set up dev wlan0
ip addr add 192.168.3.1/24 dev wlan0

sysctl net.ipv4.ip_forward=1

iptables -t nat -A POSTROUTING -o ppp0 -j MASQUERADE
iptables -A FORWARD -i wlan0 -o ppp0 -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
' > hotspot.sh
chmod +x hotspot.sh

cd /etc/systemd/system
echo '
[Unit]
Description=hostapd for rtl8192cu
Wants=network.target

[Service]
Type=simple
ExecStart=/usr/bin/hostapd hostapd.conf

[Install]
WantedBy=multi-user.target
' > hostapd.service
mv /usr/lib/systemd/system/hostapd.service /usr/lib/systemd/system/hostapd.service.bak
systemctl enable hostapd
systemctl start hostapd

cd /etc/systemd/system
echo '
[Unit]
Description=hotspot
Wants=network.target

[Service]
Type=oneshot
ExecStart=/root/hotspot.sh

[Install]
WantedBy=multi-user.target
' > hotspot.service
systemctl enable hotspot
systemctl start hotspot

cd /etc
echo '
option domain-name-servers 199.91.73.222;
option subnet-mask 255.255.255.0;
option routers 192.168.3.1;
subnet 192.168.3.0 netmask 255.255.255.0 {
    range 192.168.3.1 192.168.3.254;
}
' > dhcpd.conf
systemctl enable dhcpd4
systemctl start dhcpd4


