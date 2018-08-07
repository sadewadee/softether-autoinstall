#!/bin/bash
RED='\033[0;31m'
NC='\033[0m' # No Color
(( EUID != 0 )) && exec sudo -- "$0" "$@"
clear
read -p "$(echo -e 'This will COMPLETELY remove SoftEther VPN from your server.\nThis will only work if you used the softether-install script.\n\nAre you sure you want to contiunue? [y/N]\n\b')" response
case $response in
[yY][eE][sS]|[yY])
printf "\nPurging SE-VPN processes and/or files.\n"
cd ~
rm se-autoinstall
rm softether*
service vpnserver stop > /dev/null 2>&1
update-rc.d vpnserver remove > /dev/null 2>&1
rm /etc/init.d/vpnserver > /dev/null 2>&1
rm -rf /usr/local/vpnserver > /dev/null 2>&1
printf "\nDone. Do you want to download and run the softether-autoinstall script? [y/N]\n\b"
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
  wget -O se-autoinstall https://raw.githubusercontent.com/icoexist/softether-autoinstall/beta/ubuntu/x64/se-install-ubuntu.bash && chmod 770 se-autoinstall && ./se-autoinstall
else
  printf "\nAlright, we're done here!\n\b"
fi
esac
