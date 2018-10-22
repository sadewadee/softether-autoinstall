#!/bin/bash

# Define console colors
RED='\033[0;31m'
NC='\033[0m' # No Color
(( EUID != 0 )) && exec sudo -- "$0" "$@"
clear

# User confirmation
read -r -p "This will download and compile SoftEther VPN on your server. Are you sure you want to continue? [y/N] " response
case $response in
[yY][eE][sS]|[yY])

# Create & CD into working directory
printf "\nMaking sure that there are no previous SoftEther downloads/folders in this current directory.\n\n"
rm -rf ~/se-vpn > /dev/null 2>&1
mkdir ~/se-vpn && cd se-vpn
update-rc.d vpnserver remove > /dev/null 2>&1
rm /etc/init.d/vpnserver > /dev/null 2>&1
printf "\n${RED}build-essential${NC} and ${RED}checkinstall${NC} are required. Installing those now.\n\n"
add-apt-repository universe > /dev/null 2>&1
apt update && apt install checkinstall build-essential -y

# Download SoftEther | Version 4.27 | Build 9668
printf "\nDownloading last stable release: ${RED}4.27${NC} | Build ${RED}9668${NC}\n\n"
cd ~/se-vpn && wget -O softether-vpn-4.27.tar.gz https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/releases/download/v4.28-9669-beta/softether-vpnserver-v4.28-9669-beta-2018.09.11-linux-x64-64bit.tar.gz
tar -xzf softether-vpn-4.27.tar.gz
cd vpnserver
echo $'1\n1\n1' | make
cd ~/se-vpn
mv vpnserver/ /usr/local/
chmod 600 /usr/local/vpnserver/* && chmod 700 /usr/local/vpnserver/vpncmd && chmod 700 /usr/local/vpnserver/vpnserver
cd ~/se-vpn && wget -O vpnserver-init https://raw.githubusercontent.com/icoexist/softether-autoinstall/master/vpnserver-init
mv vpnserver-init /etc/init.d/vpnserver
chmod 755 /etc/init.d/vpnserver
printf "\nSystem daemon created. Registering changes...\n\n"
update-rc.d vpnserver defaults
printf "\nSoftEther VPN Server should now start as a system service from now on.\n\n"

# Open ports for SoftEther VPN Server
printf "\nNow opening ports for SSH and SoftEther.\n\n"
ufw allow 443,1194,5555/tcp && ufw allow 500,1701,4500/udp && ufw allow ssh
systemctl start vpnserver
printf "\nCleaning up...\n\n"
cd ~ && rm -rf ~/se-vpn/ > /dev/null 2>&1
systemctl status vpnserver
printf "\nIf the output above shows vpnserver.service to be active (running), then SoftEther VPN has been successfully installed and is now running.\nTo configure the server, use the SoftEther VPN Server Manager located here: https://bit.ly/2NFGNWa\n\n"
printf "\n${RED}REMINDER:${NC}\n\nUFW will not be enabled with this script.\n\nYou must either manually add your SSH port with ${RED}ufw allow x/tcp${NC} where x = your SSH port.\n\nThen you can issue ${RED}sudo ufw enable${NC}\n\n"
esac
