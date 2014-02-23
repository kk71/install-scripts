#!/bin/bash

# after reboot or partprobe works
echo "after reboot."
resize2fs /dev/mmcblk0p5

echo ": install packages..."
pacman --noconfirm -S python python2 python-pip python2-pip python-virtualenv goagent

#config pip with mirror to douban.com
cd
mkdir .pip
echo "[global]
index-url = http://pypi.douban.com/simple" > ~/.pip/pip.conf

systemctl enable goagent
echo "[gae]
appid = tabemonogahoshii
" > /etc/goagent
echo ": Now turn on goagent proxy and export it to pacman..."
systemctl start goagent
export http_proxy=http://127.0.0.1:8087
sleep 6s;

pacman --noconfirm -S imagemagick links lynx htop unzip unrar fish dhcp bind hostapd ntp ppp
systemctl enable ntpd

pacman --noconfirm -S mplayer moc
pacman --noconfirm -S sqlite3 mariadb redis
pacman --noconfirm -S ruby go gcc cmake make
pacman --noconfirm -S git subversion 
pacman --noconfirm -S vim vim-systemd

echo ": config git..."
git config --global user.name "kk"
git config --global user.email "fkfkbill@gmail.com"
git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=3600'
git config --global push.default current

echo ": get my vim rc files..."
pacman --noconfirm -S ctags python-pylint astyle
pip install autopep8
cd
git clone https://github.com/kk71/vim.git
mv vim .vim
ln -s .vim/vimrc .vimrc
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle


echo ": get rpi-ddns..."
cd
git clone https://github.com/kk71/raspi-ddns.git

echo ": get dropbox-backup..."
cd
git clone https://github.com/kk71/dropbox-backup.git
cd dropbox-backup


